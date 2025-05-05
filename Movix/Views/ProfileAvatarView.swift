//
//  ProfileAvatarView.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI

struct ProfileAvatarView: View {
    let avatarData: Data?
    let username: String
    var body: some View {
        VStack(spacing: 10) {
            if let avatarData, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 104, height: 105)
                    .clipShape(.circle)
                    .overlay {
                        Circle().stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                    }
            } else {
                Image(.profileDefault)
                    .resizable()
                    .frame(width: 104, height: 104)
            }
            Text(username)
                .font(.hauora(size: 20))
                .foregroundStyle(.bw50)
        }
        .animation(.easeIn, value: avatarData)
    }
}
