//
//  FriendRow.swift
//  Movix
//
//  Created by Ancel Dev account on 15/4/25.
//

import SwiftUI

struct FriendRow<Content:View>: View {
    let friend: User
    let content: () -> Content
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(.profileDefault)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                VStack(alignment: .leading) {
                    Text(friend.username)
                        .font(.hauora(size: 20))
                        .foregroundStyle(.white)
                    Text("Online")
                        .font(.hauora(size: 12))
                        .foregroundStyle(.blue1)
                }
            }
            Spacer()
            content()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .background(.bw20)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack {
        FriendRow(friend: PreviewData.user) {
            Button {
                print("Add friend")
            } label: {
                Image(.group)
            }
            .padding(.trailing, 10)
        }
    }
    .padding(.horizontal, 16)
}
