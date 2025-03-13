//
//  OverviewView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct OverviewView: View {
    let title: String?
    let overview: String?
    @State var viewMore: Int? = 3
    
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                if let title {
                    Text(title)
                        .font(.hauora(size: 20, weight: .semibold))
                }
                VStack(alignment: .leading) {
                    if let overview {
                        Text(overview)
                            .frame(maxWidth: .infinity)
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
//            .padding([.horizontal, .top], 16)
            .padding(.horizontal, 16)
        }
    }
}
//#Preview(body: {
//    MediaScreen(mediaId: Movie.preview.id, mediaType: .movie)
////        .environment(AuthViewModel())
//})
