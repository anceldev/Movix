//
//  ActorLink.swift
//  Movix
//
//  Created by Ancel Dev account on 9/5/25.
//

import SwiftUI

struct ActorLink: View {
    let imageUrl: URL?
    let name: String
    let maxWidth: CGFloat
    
    init(imageUrl: URL?, name: String, maxWidth: CGFloat = 80) {
        self.imageUrl = imageUrl
        self.name = name
        self.maxWidth = maxWidth
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            CircularProfileImage(imageURL: imageUrl)
            VStack {
                Text(name)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
//                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(maxWidth: maxWidth, alignment: .center)
                    .frame(maxHeight: 30, alignment: .top)
                    .font(.hauora(size: 12))
            }
        }
    }
}
