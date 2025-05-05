//
//  FriendsListView.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//

import FlagsKit
import SwiftUI

struct FriendsListView: View {
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(userVM.user.friends, id: \.id) { request in
                    FriendRow(friend: request.friend) {
                        FlagView(countryCode: request.friend.country)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    FriendsListView()
        .environment(UserViewModel(user: PreviewData.user))
}
