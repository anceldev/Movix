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
    typealias Client = SupClient
    let supabase = Client.shared.supabase
    
    var users = [User]()
    
    func getUsers(query: String) async {
        do {
            let response = try await supabase
                .from(SupabaseTables.users.rawValue)
                .select("*")
                .ilike("username", pattern: "%\(query)%") 
                .execute()
            
            print(String(decoding: response.data, as: UTF8.self))
            let users = try JSONDecoder().decode([User].self, from: response.data)
            self.users = users
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    func addFriend(userId: UUID, friendId: UUID) async {
        do {
            let response = try await supabase
                .from(SupabaseTables.friends.rawValue)
                .insert(["user_id": userId, "friend_id": friendId])
                .execute()
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
