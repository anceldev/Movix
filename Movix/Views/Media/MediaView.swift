//
//  MediaView.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

struct MediaView<Content: View, TabContent: View>: View {

    let overview: String?
    let mediaType: MediaType
    let poster: Content
    let tabContent: TabContent
    
    init(overview: String? = nil, mediaType: MediaType, @ViewBuilder poster: () -> Content, @ViewBuilder tabContent: () -> TabContent) {
        self.overview = overview
        self.mediaType = mediaType
        self.poster = poster()
        self.tabContent = tabContent()
    }
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            VStack {
                                poster
                            }
                            // Actions bar zone
//                            MediaActionsBar(
//                                rateAction: {
//                                    proxy.scrollTo("mediaTabs")
//                                },
//                                mediaType: mediaType
////                                favoriteAction: {}
//                            )
//                            OverviewView(overview: overview)
                            tabContent
                                .id("mediaTabs")
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                
            }
//            BannerTopBar()
//                .padding(.top, 44)
        }
    }
}

//#Preview {
//    MediaView {
//        
//    }
//}
