//
//  FriendsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 15/4/25.
//

import SwiftUI

enum FriendsTabs: String, CaseIterable, Identifiable, Hashable, Localizable {
    case friends, requests, sended
    
    var id: Self { self }
    
    var localizedTitle: String {
        switch self {
        case .friends:
            return NSLocalizedString("account-friends-friends-tab", comment: "friends")
        case .requests:
            return NSLocalizedString("account-friends-requests-tab", comment: "requests")
        case .sended:
            return NSLocalizedString("account-friends-sended-tab", comment: "sended")
//        case .search:
//            return NSLocalizedString("account-friends-search-tab", comment: "search")
        }
    }
}

struct FriendsScreen: View {
    @Environment(UserViewModel.self) var userVM
    @State private var selectedTab = FriendsTabs.friends
    var body: some View {
        VStack {
            VStack {
                CustomSegmentedControl(state: $selectedTab, horizontalPadding: 24)
                switch selectedTab {
                case .friends:
                    FriendsListView()
                        .environment(userVM)
                case .requests:
                    RequestsListView()
                        .environment(userVM)
                case .sended:
                    SendedRequestListView()
                        .environment(userVM)
                    
//                case .search:
//                    SearchFriendView()
                }
            }
            
//            ForEach(userVM.friends) { friend in
//                FriendRow(friend: friend) {
//                    Button {
//                        print("Add friend")
//                    } label: {
//                        Image(.group)
//                    }
//                    .padding(.trailing, 10)
//                }
//            }
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .onAppear {
            Task {
                await userVM.getFriends()
            }
        }
    }
}

#Preview {
    FriendsScreen()
        .environment(UserViewModel(user: PreviewData.user))
}
