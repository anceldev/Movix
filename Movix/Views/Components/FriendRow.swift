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

#Preview("Add friend") {
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

#Preview("Accept friend") {
    VStack {
        FriendRow(friend: PreviewData.user) {
            Button {
                print("Add friend")
            } label: {
                HStack(spacing: 4) {
                    Text("Accept")
                    Image(.done)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .font(.hauora(size: 12))
                .foregroundStyle(.blue1)
                .clipShape(.capsule)
                .overlay {
                    Capsule()
                        .stroke(.blue1, lineWidth: 1)
                }
            }
            .padding(.trailing, 10)
        }
    }
    .padding(.horizontal, 16)
}
#Preview("Deny friend") {
    VStack {
        FriendRow(friend: PreviewData.user) {
            HStack(spacing: 6) {
                Button {
                    print("Add friend")
                } label: {
                    HStack(spacing: 4) {
                        Text("Accept")
                        Image(.done)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .font(.hauora(size: 12))
                    .foregroundStyle(.blue1)
                    .clipShape(.capsule)
                    .overlay {
                        Capsule()
                            .stroke(.blue1, lineWidth: 1)
                    }
                }
                Button {
                    print("deny friend")
                } label: {
                    HStack(spacing: 4) {
                        Text("Deny")
                            .fontWeight(.bold)
                        Image(.close)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .font(.hauora(size: 12))
                    .foregroundStyle(.marsA)
                    .clipShape(.capsule)
                    .overlay {
                        Capsule()
                            .stroke(.marsA, lineWidth: 1)
                    }
                }
            }
        }
    }
    .padding(.horizontal, 16)
}
