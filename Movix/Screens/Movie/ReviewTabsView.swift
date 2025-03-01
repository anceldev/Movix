//
//  ReviewTabsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ReviewsTabView: View {
    
    @Environment(MovieViewModel.self) var movieVM
    
    var body: some View {
        VStack {
            if movieVM.reviews.isEmpty {
                Text("There is no available reviews for \(movieVM.movie?.title ?? "NO-NAME")")
            }
            else {
                VStack(spacing: 20) {
                    LazyVStack {
                        ForEach(movieVM.reviews, id: \.id) { review in
                            ReviewView(review: review)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 24)
        .onAppear {
            Task {
                await movieVM.getMovieReviews(id: movieVM.movie?.id ?? 0)
            }
        }
    }
}

#Preview {
    ReviewsTabView()
        .environment(MovieViewModel())
        .background(.bw10)
}
