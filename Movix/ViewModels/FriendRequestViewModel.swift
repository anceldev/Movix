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
    var errorMessage: String?
    
    func getFriends(userId: UUID) async {
        do {
            let response = try await supabase
                .from("friendship")
                .select("""
                    id,
                    user_1(*),
                    user_2(*)
                    """)
                .or("user_1.eq.\(userId),user_2.eq.\(userId)")
                .execute()
            print(String(decoding: response.data, as: UTF8.self))
        } catch  {
            print(error)
            print(error.localizedDescription)
        }
    }
    
    func sendFriendRequest(from user: UUID, to friend: UUID) async {
        do {
            let newRequest = FriendshipRequestDTO(user1: user, user2: friend)
            let sendRequest = try await supabase
                .from("friendship")
                .insert(newRequest)
                .execute()
                .data
            
            print(String(decoding: sendRequest, as: UTF8.self))
                
        } catch {
            setError(error)
        }
    }
    
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
            setError(error)
        }
    }
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
    }
}
