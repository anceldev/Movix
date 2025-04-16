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
                ForEach(requestsVM.requests) { request in
                    FriendRow(friend: request.user) {
                        Button {
                            acceptRequest(id: request.id)
                        } label: {
                            Text("Accept")
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .task {
            await requestsVM.getFriendRequests(userId: userVM.user.id)
        }
    }
    private func acceptRequest(id: Int) {
        Task {
            await requestsVM.acceptRequest(id: id)
        }
    }
}

#Preview {
    RequestsListView()
        .environment(UserViewModel(user: User.preview))
}
