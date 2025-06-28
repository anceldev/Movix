//
//  SearchFriendsViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import Foundation
import Observation

@Observable
final class SearchFriendsViewModel {
    typealias Client = MovixClient
    let supabase = Client.shared.supabase
    
    var users = [User]()
    var errorMessage: String?
    
    func getUsers(query: String) async {
        do {
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .select("*")
                .ilike("username", pattern: "%\(query)%") 
                .execute()
            
//            print(String(decoding: response.data, as: UTF8.self))
            let users = try JSONDecoder().decode([User].self, from: response.data)
            self.users = users
        } catch {
            setError(error)
        }
    }
    func addFriend(userId: UUID, friendId: UUID) async {
        do {
            let response: User = try await supabase
                .from(SupabaseTables.friends.rawValue)
                .insert(["user_id": userId, "friend_id": friendId])
                .execute()
                .value
            
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
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
