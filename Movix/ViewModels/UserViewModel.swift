//
//  UserViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation
import SwiftUI
import Supabase

enum UserViewModelError: Error {
    case avatarUploadError
    case avatarCompressionError
    case avatarLocalSaveError
}

@Observable
final class UserViewModel {
    
    typealias Client = SupClient
    let supabase = Client.shared.supabase
     
    var user: User
    var languages = [Language]()
    var countries = [Country]()
    var friends = [User]()
    
    var errorMessage: String?
    private let fileManager = FileManager.default
    
    private var avatarFileURL: URL? {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        guard let _ = user.avatarPath else { return nil }
        return documentsDirectory.appendingPathComponent("\(user.id.uuidString).jpg")
    }
    
    init(user: User) {
        self.user = user
        Task {
            await getAvatar()
            await getUserSeries(.serie)
            await getUserSeries(.movie)
            await getLists()
            await getLanguages()
            await getCountries()
        }
    }
    
    private func getUserSeries(_ mediaType: MediaType) async {
        do {
            let tableName = "user_\(mediaType.rawValue)s"
            let series: [TestUserMedia] = try await supabase
                .from(tableName)
                .select("""
                id,
                \(mediaType.rawValue)_id(*),
                is_favorite,
                rating
                """)
                .eq("user_id", value: user.id)
                .execute()
                .value
            if mediaType == .serie {
                user.series = series
            } else {
                user.movies = series
            }
        } catch {
            setError(error)
        }
    }
    
    func getFriends() async {
        do {
            let response: [FriendshipResponseDTO] = try await supabase
                .from("friendship")
                .select("""
                    id,
                    user_1(id, username, avatar_path, email, lang, country),
                    user_2(id, username, avatar_path, email, lang, country),
                    status
                    """)
                .or("user_1.eq.\(user.id),user_2.eq.\(user.id)")
                .execute()
                .value

            var friends = [Friend]()
            var sended = [Friend]()
            var received = [Friend]()
            
            for relationship in response {
                if relationship.status == .accepted {
                    friends.append(
                        Friend(
                            id: relationship.id,
                            friend: relationship.user1.id == user.id ? relationship.user2 : relationship.user1,
                            status: .accepted
                        )
                    )
                } else {
                    if relationship.user1.id == user.id {
                        sended.append(
                            Friend(
                                id: relationship.id,
                                friend: relationship.user2,
                                status: relationship.status
                            )
                        )
                    } else {
                        received.append(
                            Friend(
                                id: relationship.id,
                                friend: relationship.user1,
                                status: relationship.status
                            )
                        )
                    }
                }
            }
            user.friends = friends
            user.requestsSended = sended
            user.requestsReceived = received
            
        } catch {
            setError(error)
        }
    }
    func sendFriendRequest(from user: UUID, to friend: UUID) async {
        do {
            let newRequest = FriendshipRequestDTO(user1: user, user2: friend)
            let sendRequest = try await supabase
                .from("friendship")
                .insert(newRequest)
                .execute()
        } catch {
            setError(error)
        }
    }
    func resolveFriendRequest(id: Int, status: FriendshipStatus) async {
        do {
            let response: FriendshipResponseDTO = try await supabase
                .from("friendship")
                .update(["status": status.rawValue])
                .eq("id", value: id)
                .select("""
                    id,
                    user_1(*),
                    user_2(*),
                    status
                    """)
                .single()
                .execute()
                .value
            let friend = Friend(
                id: response.id,
                friend: user.id == response.user1.id ? response.user2 : response.user1,
                status: response.status
            )
            user.friends.removeAll { $0.id == response.id }
            user.friends.append(friend)
        } catch {
            setError(error)
        }
    }
    func cancelFriendRequest(id: Int) async {
        do {
            let deleteRequest: FriendshipResponseDTO = try await supabase
                .from("friendship")
                .delete()
                .eq("id", value: id)
                .select("""
                    id,
                    user_1(*),
                    user_2(*),
                    status
                    """)
                .single()
                .execute()
                .value
            
            user.requestsSended.removeAll { $0.id == deleteRequest.id }
        } catch {
            setError(error)
        }
    }
    
    func getAvatar() async {
        guard let path = user.avatarPath else { return }
        do {
            if let avatarData = loadAvatarFromDisk() {
                user.avatarData = avatarData
                return
            }
            let avatarData = try await supabase.storage
                .from("avatars")
                .download(path: path)
            user.avatarData = avatarData
            try saveAvatarToDisk(avatarData)
        } catch {
            setError(error)
        }
    }
    func updateAvatar(uiImage: UIImage?) async {
        guard let uiImage else { return }
        do {
            let path = try await uploadAvatar(uiImage: uiImage)
            let _ = try await supabase
                .from("users")
                .update(["avatar_path": path])
                .eq("id", value: user.id)
                .execute()
            user.avatarPath = path
        } catch {
            setError(error)
        }
    }
    func uploadAvatar(uiImage: UIImage) async throws -> String {
        do {
            guard let resizedImage = uiImage.resizeTo(to: 150),
                  let imageData = resizedImage.jpegData(compressionQuality: 0.8)
            else {
                throw UserViewModelError.avatarCompressionError
            }
            
            let response = try await supabase.storage
                .from("avatars")
                .update(
                    "avatars/\(user.id.uuidString)",
                    data: imageData,
                    options: FileOptions(
                        cacheControl: "3600",
                        contentType: "image/jpeg",
                        upsert: false
                    )
                )
            try saveAvatarToDisk(imageData)
            return response.path
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    private func loadAvatarFromDisk() -> Data? {
        guard let fileURL = avatarFileURL else { return nil }
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            setError(error)
            return nil
        }
    }
    private func saveAvatarToDisk(_ data: Data) throws {
        guard let fileURL = avatarFileURL else { return }
        do {
            try data.write(to: fileURL)
        } catch {
            setError(error)
            throw error
        }
    }
    private func clearStoreAvatar() {
        guard let fileURL = avatarFileURL else { return }
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            setError(error)
        }
    }
    
    func updateUserLanguage(lang: String?) async -> Void {
        guard let lang, lang != user.lang else { return }
        do {
            let _ = try await supabase
                .from("users")
                .update(["lang": lang])
                .eq("id", value: user.id)
                .execute()
            UserDefaults.standard.set(lang, forKey: "lang")
            user.lang = lang
        } catch {
            setError(error)
        }
    }
    func updateUserCountry(country: String?) async -> Void {
        guard let country, country != user.country else { return }
        do {
            let _ = try await supabase
                .from("users")
                .update(["country": country])
                .eq("id", value: user.id)
                .execute()
            UserDefaults.standard.set(country, forKey: "country")
            user.country = country
        } catch {
            setError(error)
        }
    }
    
    func toggleFavoriteMedia<T: MediaTMDBProtocol>(media: T, mediaType: MediaType) async {
        let relationshipTable = "user_\(mediaType.rawValue)s"
        let mediaTable = "\(mediaType.rawValue)s"
        do {
            let existingFavorite = mediaType == .movie
            ? user.movies.first(where: { $0.media.id == media.id })
            : user.series.first(where: { $0.media.id == media.id })
            
            if let existingFavorite {
                /// Si existe entre las series o peliculas del usuario, actualizo
                let updatedMedia: TestUserMedia = try await supabase
                    .from(relationshipTable)
                    .update(["is_favorite": !existingFavorite.isFavorite])
                    .eq("id", value: existingFavorite.id)
                    .select("""
                        id,
                        \(mediaType.rawValue)_id(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                if mediaType == .movie {
                    user.movies.removeAll { $0.id == updatedMedia.id }
                } else {
                    user.series.removeAll { $0.id == updatedMedia.id }
                }
                if updatedMedia.isFavorite {
                    if mediaType == .movie {
                        user.movies.append(updatedMedia)
                    } else {
                        user.series.append(updatedMedia)
                    }
                }
            } else {
                /// Si no existe, lo añado a su tabla correspondiente y despues añado también la relación
                let movie = SupabaseMedia(id: media.id, posterPath: media.posterPath)
                let existingMovie: SupabaseMedia = try await supabase
                    .from(mediaTable)
                    .upsert(movie)
                    .single()
                    .execute()
                    .value
                
                let addedMovie: TestUserMedia = try await supabase
                    .from(relationshipTable)
                    .insert([
                        "user_id": user.id.uuidString,
                        "\(mediaType.rawValue)_id": "\(existingMovie.id)",
                        "is_favorite": "true"
                    ])
                    .select("""
                        id,
                        "\(mediaType.rawValue)_id"(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                if mediaType == .movie {
                    user.movies.append(addedMovie)
                } else {
                    user.series.append(addedMovie)
                }
            }
        } catch {
            setError(error)
        }
    }
    func rateMedia<T: MediaTMDBProtocol>(media: T, rating: Int, mediaType: MediaType) async {
        let relationshipTable = "user_\(mediaType.rawValue)s"
        let tableName = "\(mediaType.rawValue)s"
        
        do {
            let existingMedia = mediaType == .movie
            ? user.movies.first { $0.media.id == media.id }
            : user.series.first { $0.media.id == media.id }
            
            if let existingMedia {
                let updatedMedia: TestUserMedia = try await supabase
                    .from(relationshipTable)
                    .update([
                        "user_id": "\(user.id.uuidString)",
                        "\(mediaType.rawValue)_id": "\(media.id)",
                        "is_favorite": existingMedia.isFavorite ? "true" : "false",
                        "rating": "\(rating)"
                    ])
                    .eq("id", value: existingMedia.id)
                    .select("""
                        id,
                        \(mediaType.rawValue)_id(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                if mediaType == .movie {
                    let index = user.movies.firstIndex { $0.id == updatedMedia.id }
                    user.movies[index!].rating = rating
                } else {
                    let index = user.series.firstIndex { $0.id == updatedMedia.id }
                    user.series[index!].rating = rating
                }
                
            } else {
                let addedMedia: SupabaseMedia = try await supabase
                    .from(tableName)
                    .upsert([
                        "id": "\(media.id)",
                        "poster_path": media.posterPath
                    ])
                    .select()
                    .single()
                    .execute()
                    .value
                
                let addRelationship: TestUserMedia = try await supabase
                    .from(relationshipTable)
                    .insert([
                        "user_id": "\(user.id.uuidString)",
                        "\(mediaType.rawValue)_id": "\(addedMedia.id)",
                        "is_favorite": "false",
                        "rating": "\(rating)"
                    ])
                    .select("""
                        id,
                        \(mediaType.rawValue)_id(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                
                if mediaType == .movie {
                    user.movies.append(addRelationship)
                } else {
                    user.series.append(addRelationship)
                }
            }
        } catch {
            setError(error)
        }
    }
    
    
    func getMovieRating(movieId: Int) -> Int? {
        return user.movies.first { $0.media.id == movieId }?.rating
    }
    func getSerieRating(serieId: Int) -> Int? {
        return user.series.first { $0.media.id == serieId }?.rating
    }
    
    private func getLists() async {
        do {
            let lists: [MediaList] = try await supabase
                .from("lists")
                .select("""
                    id,
                    name,
                    description,
                    list_type,
                    owner_id(*),
                    is_public,
                    movies_list(
                        movies(
                            id,
                            poster_path
                        )
                    ),
                    series_list(
                        series(
                            id,
                            poster_path
                        )
                    )
                    """)
                .eq("owner_id", value: user.id.uuidString)
                .execute()
                .value
            user.lists = lists
        } catch {
            setError(error)
        }
    }
    func createList(name: String, description: String? = nil, isPublic: Bool, listType: MediaType) async {
        do {
            let list = MediaList(name: name, description: description, listType: listType, owner: user, isPublic: isPublic)
            let newList: MediaList = try await supabase
                .from("lists")
                .insert(list)
                .select("""
                    id,
                    name,
                    description,
                    list_type,
                    owner_id(*),
                    is_public
                    """)
                .single()
                .execute()
                .value
            user.lists.append(newList)
        } catch {
            setError(error)
        }
    }
    func addMediaToList(media: SupabaseMedia, listId: Int, mediaType: MediaType) async {
        let table = "\(mediaType.rawValue)s_list"
        
        do {
            let addNewMedia: SupabaseMedia = try await supabase
                .from("\(mediaType.rawValue)s")
                .upsert(media)
                .single()
                .execute()
                .value
            if mediaType == .movie {
                let addedMedia: MovieListRelation  = try await supabase
                    .from(table)
                    .insert(["list_id":"\(listId)", "\(mediaType.rawValue)_id":"\(addNewMedia.id)", "added_by": "\(user.id.uuidString)"])
                    .select("""
                          movies(
                              id,
                              poster_path
                          )
                        """
                    )
                    .single()
                    .execute()
                    .value
                let listIndex = user.lists.firstIndex { $0.id == listId }
                user.lists[listIndex!].items.append(addedMedia.movies)
            } else {
                let addedMedia: SeriesListRelation  = try await supabase
                    .from(table)
                    .insert(["list_id":"\(listId)", "\(mediaType.rawValue)_id":"\(addNewMedia.id)", "added_by": "\(user.id.uuidString)"])
                    .select("""
                      series(
                          id,
                          poster_path
                      )
                    """
                    )
                    .single()
                    .execute()
                    .value
                let listIndex = user.lists.firstIndex { $0.id == listId }
                user.lists[listIndex!].items.append(addedMedia.series)
            }
        } catch {
            setError(error)
        }
    }
    func removeMediaFromList(mediaId: Int, listId: Int, mediaType: MediaType) async {
        let table = "\(mediaType.rawValue)s_list"
        do {
            let _ = try await supabase
                .from(table)
                .delete()
                .eq("\(mediaType.rawValue)_id", value: mediaId)
                .eq("list_id", value: listId)
                .execute()
            
            let listIndex = user.lists.firstIndex { $0.id == listId }
            user.lists[listIndex!].items.removeAll { $0.id == mediaId }
        } catch {
            setError(error)
        }
    }
    
    
    func getLanguages() async {
        do {
            languages = try await TMDBService.shared.getLanguages(lang: user.lang)
            languages.sort { $0.englishName < $1.englishName }
        } catch {
            setError(error)
        }
    }
    func getCountries() async {
        do {
            self.countries = try await TMDBService.shared.getCountries(lang: user.lang, country: user.country)
            countries.sort { $0.nativeName < $1.nativeName }
        } catch {
            setError(error)
        }
    }
    func getMediaCountries(_ codes: [String]) -> String {
        if self.countries.isEmpty { return "" }
        var foundedCountries: [Country] = []
        for code in codes {
            if let newCountry = self.countries.first(where: { $0.iso31661 == code }) {
                foundedCountries.append(newCountry)
            }
        }
        return foundedCountries.map { $0.nativeName }.joined(separator: ", ")
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
