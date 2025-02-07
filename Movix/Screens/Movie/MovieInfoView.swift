//
//  MovieInfoView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MovieInfoView: View {
    //    let overview: String
    let cast: [Cast]
    let overview: String?
    @State var viewMore: Int? = 3
    
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                VStack(alignment: .leading) {
                    if let overview {
                        Text(overview)
                            .lineLimit(viewMore)
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            print("View more...")
                            withAnimation {
                                if(viewMore != nil) {
                                    viewMore = nil
                                } else {
                                    viewMore = 3
                                }
                            }
                        }, label: {
                            Text(viewMore == nil ? "View less" : "View More ")
                                .foregroundStyle(.blue1)
                        })
                    }
                }
            }
            .padding(16)
        }
    }
}
#Preview(body: {
    MovieScreen(movieId: Movie.preview.id)
//        .environment(AuthViewModel())
})
