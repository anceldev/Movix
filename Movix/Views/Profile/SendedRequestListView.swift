//
//  SendedRequestListView.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//

import SwiftUI

struct SendedRequestListView: View {
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(userVM.user.requestsSended, id: \.id) { request in
                    FriendRow(friend: request.friend) {
                        HStack(spacing: 6) {
                            Button {
                                cancelRequest(id: request.id!, status: .denied)
                            } label: {
                                FriendshipRequestButton(label: "Cancel", image: Image(.close), color: .mars)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    private func cancelRequest(id: Int, status: FriendshipStatus) {
        Task {
            await userVM.resolveFriendRequest(id: id, status: status)
        }
    }
}

#Preview {
    SendedRequestListView()
}
