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
    private var favoritesPage = 1
    private var ratedMoviesPage = 1
    private var favoriteSeriesPage = 1
    private var ratedSeriesPage = 1
    
    private var httpClient = HTTPClient()
    private var sessionId = UserDefaults.standard.string(forKey: "session_id") ?? ""

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
            await getUserSeries()
            await getUserMovies()
            await getLists()
        }
    }
    
    private func getUserSeries() async {
        do {
            let series: [TestUserSerie] = try await supabase
                .from("user_series")
                .select("""
                id,
                user_id,
                series(*),
                is_favorite,
                rating
                """)
                .eq("user_id", value: user.id)
                .execute()
                .value
            user.series = series
        } catch {
            setError(error)
        }
    }
    private func getUserMovies() async {
        do {
            let movies: [TestUserMovie] = try await supabase
                .from("user_movies")
                .select("""
                id,
                user_id,
                movies(*),
                is_favorite,
                rating
                """)
                .eq("user_id", value: user.id)
                .execute()
                .value
            user.movies = movies
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
            
//            let friends: [Friend] = response.compactMap { row in
//                return Friend(
//                    id: row.id,
//                    friend: row.user1.id == user.id ? row.user2 : row.user1,
//                    status: row.status
//                )
//            }
//            let friends = response.filter { $0.status == .accepted }
//            let friends = response.compactMap {
//                if $0.status == .accepted {
//                    return Friend(
//                        id: $0.id,
//                        friend: $0.user1.id == user.id ? $0.user2 : $0.user1,
//                        status: $0.status
//                    )
//                }
//                return nil
//            }
//            let requestsSended = response.compactMap {
//                if $0.user1.id == user.id {
//                    return Friend(
//                        id: $0.id,
//                        friend: $0.user2,
//                        status: $0.status
//                    )
//                }
//                return nil
//            }
//            let requestsReceived = response.compactMap {
//                if $0.user2.id == user.id {
//                    return Friend(
//                        id: $0.id,
//                        friend: $0.user1,
//                        status: $0.status
//                    )
//                }
//                return nil
//            }
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
            
//            user.friends = friends
//            user.requestsSended = requestsSended
//            user.requestsReceived = requestsReceived
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
            
            print(String(decoding: sendRequest.data, as: UTF8.self))
                
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
            saveAvatarToDisk(avatarData)
        } catch {
            setError(error)
        }
    }
    func updateAvatar(uiImage: UIImage?) async {
        guard let uiImage else { return }
        do {
            let path = try await uploadAvatar(uiImage: uiImage)
            let _ = try await supabase
                .from(SupabaseTables.users.rawValue)
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
            else { throw UserViewModelError.avatarCompressionError }
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
            saveAvatarToDisk(imageData)
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
    private func saveAvatarToDisk(_ data: Data) {
        guard let fileURL = avatarFileURL else { return }
        do {
            try data.write(to: fileURL)
        } catch {
            setError(error)
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
                .from(SupabaseTables.users.rawValue)
                .update(["lang": lang])
                .eq("id", value: user.id)
                .execute()
            user.lang = lang
        } catch {
            setError(error)
        }
    }
    func updateUserCountry(country: String?) async -> Void {
        guard let country, country != user.country else { return }
        do {
            let _ = try await supabase
                .from(SupabaseTables.users.rawValue)
                .update(["country": country])
                .eq("id", value: user.id)
                .execute()
            user.country = country
        } catch {
            setError(error)
        }
    }
    
    func toggleFavoriteMovie(movie: Movie) async {
        do {
            let existingFavorite = user.movies.first(where: { $0.media.id == movie.id })
            if existingFavorite != nil {
                let updatedMovie: TestUserMovie = try await supabase
                    .from("user_movies")
                    .update(["is_favorite": !existingFavorite!.isFavorite])
                    .eq("id", value: existingFavorite!.id)
                    .select("""
                        id,
                        user_id,
                        movies(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value

                print(updatedMovie)
                user.movies.removeAll { $0.id == updatedMovie.id }
                if updatedMovie.isFavorite {
                    user.movies.append(updatedMovie)
                }
            } else {
                let existingMovie: SupabaseMedia = try await supabase
                    .from("movies" )
                    .select()
                    .eq("id", value: movie.id)
                    .single()
                    .execute()
                    .value
                
                let newUserMovie = UserMovieRsponseDTO(userId: user.id, movieId: movie.id, isFavorite: true)
                let addedMovie: TestUserMovie = try await supabase
                    .from("user_movies")
                    .insert(newUserMovie)
                    .select("""
                        id,
                        user_id,
                        movies(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                
                user.movies.append(addedMovie)
            }
        } catch let error as PostgrestError {
            if error.code == "PGRST116" {
                do {
                    try await addMovie(serieId: movie.id, posterPath: movie.posterPath)
                    let newMovie: UserMovieRsponseDTO = .init(userId: user.id, movieId: movie.id, isFavorite: true)
                    
                    let response: TestUserMovie = try await supabase
                        .from("user_movies")
                        .insert(newMovie)
                        .select("""
                            id,
                            user_id,
                            movies(*),
                            is_favorite,
                            rating
                            """)
                        .single()
                        .execute()
                        .value
                    user.movies.append(response)
                } catch {
                    setError(error)
                }
            }
        } catch {
            setError(error)
        }
    }
    func toggleFavoriteSerie(serie: TvSerie) async {
        do {
            let existingFavorite = user.series.first(where: { $0.media.id == serie.id })
            if existingFavorite != nil {
                let updatedSerie: TestUserSerie = try await supabase
                    .from("user_series")
                    .update(["is_favorite": !existingFavorite!.isFavorite])
                    .eq("id", value: existingFavorite!.id)
                    .select("""
                        id,
                        user_id,
                        series(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value

                print(updatedSerie)
                user.series.removeAll { $0.id == updatedSerie.id }
                if updatedSerie.isFavorite {
                    user.series.append(updatedSerie)
                }
            } else {
                let existingSerie: SupabaseMedia = try await supabase
                    .from( "series" )
                    .select()
                    .eq("id", value: serie.id)
                    .single()
                    .execute()
                    .value
                
                let newUserSerie = UserSerieResponseDTO(userId: user.id, serieId: serie.id, isFavorite: true)
                let addedSerie: TestUserSerie = try await supabase
                    .from("user_series")
                    .insert(newUserSerie)
                    .select("""
                        id,
                        user_id,
                        series(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                
                user.series.append(addedSerie)
            }
        } catch let error as PostgrestError {
            if error.code == "PGRST116" {
                do {
                    try await addSerie(serieId: serie.id, posterPath: serie.posterPath)
                    let newSerie: UserSerieResponseDTO = .init(userId: user.id, serieId: serie.id, isFavorite: true)
                    
                    let response: TestUserSerie = try await supabase
                        .from("user_series")
                        .insert(newSerie)
                        .select("""
                            id,
                            user_id,
                            series(*),
                            is_favorite,
                            rating
                            """)
                        .single()
                        .execute()
                        .value
                    user.series.append(response)
                } catch {
                    setError(error)
                }
            }
        } catch {
            setError(error)
        }
    }

    private func addSerie(serieId: Int, posterPath: String?) async throws {
        do {
            let _ = try await supabase
                .from("series")
                .insert(["id": "\(serieId)", "poster_path": posterPath])
                .execute()
        } catch {
            throw error
        }
    }
    private func addMovie(serieId: Int, posterPath: String?) async throws {
        do {
            let _ = try await supabase
                .from("movies")
                .insert(["id": "\(serieId)", "poster_path": posterPath])
                .execute()
        } catch {
            throw error
        }
    }
    
    func rateSerie(serie: TvSerie, rating: Int) async {
        do {
            let existingUserSerie = user.series.first { $0.media.id == serie.id }
            if let existingUserSerie {
                let updatedSerie: TestUserSerie = try await updateRating(rowId: existingUserSerie.id!, rating: rating, table: "series")
                user.series.removeAll { $0.id == updatedSerie.id }
                user.series.append(updatedSerie)
            } else {
                let _: SupabaseMedia = try await supabase
                    .from("series")
                    .select()
                    .eq("id", value: serie.id)
                    .single()
                    .execute()
                    .value
                
                let newRatedSerie = UserSerieResponseDTO(userId: user.id, serieId: serie.id, rating: rating)
                let addedSerie: TestUserSerie = try await supabase
                    .from("user_series")
                    .insert(newRatedSerie)
                    .select("""
                        id,
                        user_id,
                        series(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                
                user.series.append(addedSerie)
            }
        } catch let error as PostgrestError {
            if error.code == "PGRST116" {
                do {
                    try await addMovie(serieId: serie.id, posterPath: serie.posterPath)
                    let newRatedMovie: UserSerieResponseDTO = .init(userId: user.id, serieId: serie.id, rating: rating)
                    let addedSerie: TestUserSerie = try await supabase
                        .from("user_series")
                        .insert(newRatedMovie)
                        .select("""
                            id,
                            user_id,
                            series(*),
                            is_favorite,
                            rating
                            """)
                        .single()
                        .execute()
                        .value
                    user.series.append(addedSerie)
                } catch {
                    setError(error)
                }
            }
        } catch {
            setError(error)
        }
    }
    func rateMovie(movie: Movie, rating: Int) async {
        do {
            let existingUserMovie = user.movies.first { $0.media.id == movie.id }
            if let existingUserMovie {
                let updatedMovie: TestUserMovie = try await updateRating(rowId: existingUserMovie.id!, rating: rating, table: "movies")
                user.movies.removeAll { $0.id == updatedMovie.id }
                user.movies.append(updatedMovie)
            } else {
                let _: SupabaseMedia = try await supabase
                    .from("movies")
                    .select()
                    .eq("id", value: movie.id)
                    .single()
                    .execute()
                    .value
                
                let newRatedMovie = UserMovieRsponseDTO(userId: user.id, movieId: movie.id, rating: rating)
                let addedMovie: TestUserMovie = try await supabase
                    .from("user_movies")
                    .insert(newRatedMovie)
                    .select("""
                        id,
                        user_id,
                        movies(*),
                        is_favorite,
                        rating
                        """)
                    .single()
                    .execute()
                    .value
                
                user.movies.append(addedMovie)
            }
        } catch let error as PostgrestError {
            if error.code == "PGRST116" {
                do {
                    try await addMovie(serieId: movie.id, posterPath: movie.posterPath)
                    let newRatedMovie: UserMovieRsponseDTO = .init(userId: user.id, movieId: movie.id, rating: rating)
                    let addedMovie: TestUserMovie = try await supabase
                        .from("user_movies")
                        .insert(newRatedMovie)
                        .select("""
                            id,
                            user_id,
                            movies(*),
                            is_favorite,
                            rating
                            """)
                        .single()
                        .execute()
                        .value
                    user.movies.append(addedMovie)
                } catch {
                    setError(error)
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
    private func updateRating<T:UserItemCollectionMediaProtocol>(rowId: Int, rating: Int, table: String) async throws -> T {
        do {
            let updatedMedia: T = try await supabase
                .from("user_\(table)")
                .update(["rating": "\(rating)"])
                .eq("id", value: rowId)
                .select("""
                    id,
                    user_id,
                    \(table)(*),
                    is_favorite,
                    rating
                    """)
                .single()
                .execute()
                .value
            return updatedMedia
        } catch {
            throw error
        }
    }
    
    private func getLists() async {
        do {
            let lists: [MediaList] = try await supabase
//            let lists = try await supabase
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
                .execute()
                .value
            user.lists = lists
//            print(String(decoding: lists.data, as: UTF8.self))
        } catch {
            setError(error)
        }
    }
    
    func getListItems(listId: Int, mediaType: MediaType) async {
        let table = "\(mediaType.rawValue)s_list"
        
        do {
            let response = try await supabase
                .from(table)
                .select("""
                    movies(*)
                    """)
                .eq("list_id", value: listId)
                .execute()
            
            print(String(decoding: response.data, as: UTF8.self))
            
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
            let addedMedia = try await supabase
                .from(table)
                .insert(["list_id":"\(listId)", "\(mediaType.rawValue)_id":"\(addNewMedia.id)", "added_by": "\(user.id.uuidString)"])
                .execute()
        } catch {
            setError(error)
        }
    }
    func removeMediaFromList(mediaId: Int, listId: Int, mediaType: MediaType) async {
        let table = "\(mediaType.rawValue)s_list"
        
        do {
            let addedMedia = try await supabase
                .from(table)
                .insert(["list_id":"\(listId)", "\(mediaType.rawValue)_id":"\(mediaId)", "added_by": "\(user.id.uuidString)"])
                .execute()
            
            print(String(decoding: addedMedia.data, as: UTF8.self))
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
