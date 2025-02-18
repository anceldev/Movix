//
//  RatesListView.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI

struct RatesListView: View {
    let ratesList: [RatesList]
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(ratesList, id: \.movie.id) { item in
                    NavigationLink {
                        MovieScreen(movieId: item.movie.tmdbId)
                            .navigationBarBackButtonHidden()
                    } label: {
                        MediaRow(title: item.movie.title, backdropPath: item.movie.backdropPath) {
                            Text(item.rate ?? 0, format: .number)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RatesListView(ratesList: [])
}
