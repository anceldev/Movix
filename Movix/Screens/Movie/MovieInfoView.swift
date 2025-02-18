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
                            .font(.hauora(size: 16))
                        
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
                            Text("View More ")
                                .foregroundStyle(.blue1)
                                .font(.hauora(size: 12))
                                .opacity(viewMore == nil ? 0 : 1)
                        })
                        .disabled(viewMore == nil)
                    }
                }
            }
            .padding([.horizontal, .top], 16)
        }
    }
}
#Preview(body: {
    MovieScreen(movieId: Movie.preview.id)
//        .environment(AuthViewModel())
})
