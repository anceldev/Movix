//
//  ReviewTabsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ReviewsList: View {
    
//    @Environment(MovieViewModel.self) var movieVM
    let id: Int
    let title: String
    let mediaType: MediaType
    @State private var reviewVM = ReviewsViewModel()
    
    
    var body: some View {
        VStack {
            if reviewVM.reviews.isEmpty {
                Text("There is no available reviews for \(title)")
            }
            else {
                VStack(spacing: 20) {
                    LazyVStack {
                        ForEach(reviewVM.reviews, id: \.id) { review in
                            ReviewView(review: review)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 24)
        .task {
            await reviewVM.getReviews(id: id, mediaType: mediaType)
        }
    }
}
