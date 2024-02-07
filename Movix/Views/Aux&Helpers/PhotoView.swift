//
//  PhotoView.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import SwiftUI

struct PhotoView: View {
    
    var image: Image
    let size: CGFloat
    init(image: Image = Image("avatarDefault"), size: CGFloat = 120) {
        self.image = image
        self.size = size
    }
    
    var body: some View {
        image
            .resizable()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(LinearGradient(colors: [.darkOrange, .orange], startPoint: .leading, endPoint: .trailing), lineWidth: 4))
            .padding(.top, 10)
    }
}

#Preview {
    let photo = Image("account_photo")
    return PhotoView(image: photo)
}
