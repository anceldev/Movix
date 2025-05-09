//
//  TitleView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/5/25.
//

import SwiftUI

struct TitleView: View {
    let title: String
    let avatarImage: UIImage?
    
    init(title: String, avatarImage: UIImage? = nil) {
        self.title = title
        self.avatarImage = avatarImage
    }
    var body: some View {
        VStack {
            VStack(spacing: 36) {
                Text(title)
                    .font(.hauora(size: 34))
                if let avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .frame(width: 104, height: 105)
                        .clipShape(.circle)
                        .overlay {
                            Circle().stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                        }
                } else {
                    VStack(spacing: 12) {
                        Image("profileDefault")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                    }
                }
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
