//
//  FriendsViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import Foundation
import Observation

@Observable
final class FriendsViewModel {
    typealias Client = MovixClient
    let supabase = Client.shared.supabase
    
//    var users = [User]()
    
//    func getFriends() async {
//        do {
//            let response = try await supabase
//                .from(SupabaseTables.friends.rawValue)
//                .select(
//                    """
//                        status
//                        """
//                )
//        } catch {
//            print(error)
//            print(error.localizedDescription)
//        }
//    }
}
