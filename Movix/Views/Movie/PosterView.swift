//
//  PosterView.swift
//  Movix
//
//  Created by Ancel Dev account on 6/11/23.
//

import SwiftUI

struct PosterView: View {
    
    var poster: Image
    var size: CGSize
    
    var body: some View {
        poster
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
            .frame(width: size.width, height: size.height)
            .overlay {
                LinearGradient(colors: [
                    .clear,
                    .clear,
                    .clear,
                    .black.opacity(0.1),
                    .black.opacity(0.5),
                    .black.opacity(0.8)
                ], startPoint: .top, endPoint: .bottom)
                .frame(height: size.height)
            }
    }
}
