//
//  FriendsView.swift
//  Movix
//
//  Created by Ancel Dev account on 31/10/23.
//

import SwiftUI

struct FriendsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        // Edit button
                    }, label: {
                        Text("Edit")
                    })
                    Spacer()
                    Button(action: {
                        // Select
                    }, label: {
                        Text("Select")
                    })
                }
                .foregroundStyle(.cyanText)
                ForEach(1..<8) { _ in
                    FriendRow()
                }
            }
            .padding()
            .background(.blackApp)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("Friends")
                        .foregroundStyle(.blackWhite)
                        .font(.title2)
                }
            })
        }
    }
}

#Preview {
    FriendsView()
}
