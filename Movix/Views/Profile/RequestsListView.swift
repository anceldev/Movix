//
//  RequestsListView.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import SwiftUI

struct RequestsListView: View {
    @State private var requestsVM = FriendRequestViewModel()
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(userVM.user.requestsReceived, id: \.id) { request in
                    FriendRow(friend: request.friend) {
                        HStack(spacing: 6) {
                            Button {
                                resolveRequest(id: request.id!, status: .accepted)
                            } label: {
                                FriendshipRequestButton(label: "Accept", image: Image(.done))
                            }
//                            Button {
//                                resolveRequest(id: request.id!, status: .denied)
//                            } label: {
//                                FriendshipRequestButton(label: "Deny", image: Image(.close), color: .mars)
//                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    private func resolveRequest(id: Int, status: FriendshipStatus) {
        Task {
            await userVM.resolveFriendRequest(id: id, status: status)
        }
    }
}

#Preview {
    RequestsListView()
        .environment(UserViewModel(user: PreviewData.user))
}
