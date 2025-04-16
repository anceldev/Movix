//
//  FriendRequestViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import Foundation
import Observation
import Supabase

@Observable
final class FriendRequestViewModel {
    typealias Client = SupClient
    let supabase = Client.shared.supabase
    
    var requests = [FriendsRequestDTO]()
    
    
    func getFriendRequests(userId: UUID) async {
        do {
            let response = try await supabase
                .from(SupabaseTables.friends.rawValue)
                .select("id, status, user_id(*)")
                .eq("friend_id", value: userId)
                .neq("status", value: FriendshipStatus.accepted.rawValue)
                .execute()
            self.requests = try JSONDecoder().decode([FriendsRequestDTO].self, from: response.data)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
    func acceptRequest(id: Int) async {
        do {
            let response = try await supabase
                .from(SupabaseTables.friends.rawValue)
                .update(["status": FriendshipStatus.accepted.rawValue])
                .eq("id", value: id)
                .execute()
            print(response.status)
            print(response.response.statusCode)
        } catch {
            print(error)
            print(error.localizedDescription)
        }
    }
}
