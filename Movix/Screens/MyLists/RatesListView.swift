//
//  RatesListView.swift
//  Movix
//
//  Created by Ancel Dev account on 10/2/25.
//

import SwiftUI

struct RatesListView: View {
    let ratedList: [Movie]
    @Environment(UserViewModel.self) var userVM
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(ratedList) { item in
                    NavigationLink {
                        MovieScreen(movieId: item.id)
                            .navigationBarBackButtonHidden()
                    } label: {
                        MediaRow(title: item.title, backdropPath: item.backdropPath, myRate: item.rating) {
                            Text(item.rating ?? 0, format: .number)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    RatesListView(ratedList: [])
//        .environment(UserViewModel(user: User.preview))
//}
