//
//  SearchFriendView.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import SwiftUI

struct SearchFriendView: View {
    @State private var query = ""
    @State private var debounceQuery = ""
    
    @State private var searchFriendsVM = SearchFriendsViewModel()
    @Environment(UserViewModel.self) var userVM
    
    var body: some View {
        VStack {
            SearchField(searchTerm: $query, debounceQuery: $debounceQuery)
            ScrollView(.vertical) {
                
                ForEach(searchFriendsVM.users) { friend in
                    FriendRow(friend: friend) {
                        Button {
                            addFriend(friendId: friend.id)
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
        .background(.bw10)
        .onChange(of: debounceQuery) { _, newValue in
            searchUsers()
        }
    }
    private func searchUsers() {
        Task {
            await searchFriendsVM.getUsers(query: debounceQuery)
        }
    }
    private func addFriend(friendId: UUID) {
        Task {
            await searchFriendsVM.addFriend(userId: userVM.user.id, friendId: friendId)
        }
    }
}

#Preview {
    SearchFriendView()
        .environment(UserViewModel(user: User.preview))
}
