//
//  PhotoView.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import SwiftUI

struct PhotoView: View {
    
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(Circle().stroke(LinearGradient(colors: [.darkOrange, .orange], startPoint: .leading, endPoint: .trailing), lineWidth: 4))
            .padding(.top, 10)
    }
}

#Preview {
    let photo = Image("account_photo")
    return PhotoView(image: photo)
}
