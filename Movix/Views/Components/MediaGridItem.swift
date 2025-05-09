//
//  MediaGridItem.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MediaGridItem: View {

    let posterPath: String?
    let voteAverage: Double?
    let userRating: Int?
    @State private var poster: Image? = nil
    
    init(posterPath: String? = nil, voteAverage: Double? = nil, poster: Image? = nil, userRating: Int? = nil) {
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.poster = poster
        self.userRating = userRating
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.bw20, .bw40], startPoint: .top, endPoint: .bottom)
            Group {
                if let poster {
                    VStack {
                        poster
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    .clipped()
                } else {
                    TimeoutProgressView()
                }
            }
            .frame(maxWidth: .infinity)

            if let voteAverage, let formattedRate = NumberFormatter.popularity.string(from: NSNumber(value: voteAverage)) {
                UnevenRating(rate: formattedRate)
            } else if let userRating {
                UnevenRating(rate: "\(userRating)")
            }
        }
        .background(.clear)
        .aspectRatio(2/3, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .task {
            let poster = await ImageLoader.shared.loadImage(for: self.posterPath, size: .poster)
            withAnimation(.easeIn) {
                self.poster = poster
            }
        }
    }
}

#Preview {
    MediaGridItem(posterPath: PreviewData.movie.posterPath, voteAverage: 8.7)
}
