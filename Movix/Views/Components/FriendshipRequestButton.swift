//
//  FriendshipRequestButton.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//

import SwiftUI


struct FriendshipRequestButton: View {
    
    let label: String
    let image: Image?
    let buttonColor: Color
    
    init(label: String, image: Image? = nil, color: Color = .blue1) {
        self.label = label
        self.image = image
        self.buttonColor = color
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .fontWeight(.bold)
            if let image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .font(.hauora(size: 12))
        .foregroundStyle(buttonColor)
        .clipShape(.capsule)
        .overlay {
            Capsule()
                .stroke(buttonColor, lineWidth: 1)
        }
    }
}
