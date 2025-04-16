//
//  AvatarView.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import SwiftUI

struct AvatarView: View {
    var avatarPath: String?
    var body: some View {
        AsyncImage(url: URL(string: avatarPath!)!, transaction: Transaction(animation: .easeIn(duration: 0.5))) { phase in
            switch phase {
            case .empty:
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 104, height: 104)
            case .success(let image):
                ZStack {
                    Color.bw50
                        .frame(width: 104, height: 104)
                        .clipShape(.circle)
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 104, height: 104)
                        .overlay {
                            Circle().stroke(.marsA, lineWidth: 2)
                        }
                }
            case .failure:
                Image(.profileDefault)
                    .resizable()
                    .frame(width: 104, height: 104)
            @unknown default:
                Image(.profileDefault)
                    .resizable()
                    .frame(width: 104, height: 104)
            }
        }
    }
}

#Preview {
    AvatarView()
}
