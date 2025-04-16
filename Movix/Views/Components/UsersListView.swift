//
//  UsersListView.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import SwiftUI

struct UsersListView: View {
    
    var users: [User]
    var tab: FriendsTabs
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(users) { user in
                    FriendRow(friend: user) {
                        Button {
                            print("Add friend")
                        } label: {
                            Image(.group)
                        }
                        .padding(.trailing, 10)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
