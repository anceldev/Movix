//
//  HomeView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    
    private var genres = ["Action", "Adventure", "Drama", "Comedy"]
    
    @State var searchText = ""
    
    var body: some View {
        VStack {
            HStack{
                Button(action: {
                    // All
                }, label: {
                    Text("All")
                })
                .frame(maxWidth: .infinity)
                Button(action: {
                    // Movies
                }, label: {
                    Text("Movies")
                })
                .frame(maxWidth: .infinity)
                Button(action: {
                    // Series
                }, label: {
                    Text("Series")
                })
                .frame(maxWidth: .infinity)
            }
            .font(.title2)
            .foregroundStyle(.textGray)
            // Genres
            NavigationView {
                List(genres, id: \.self){ genre in
                    if( searchText.isEmpty || genre.contains(searchText)) {
                        Text(genre)
                    }
                }
                
                .listStyle(.plain)

                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blackApp)
                .foregroundStyle(.blackWhite)
                .font(.title2)
                .multilineTextAlignment(.center)
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search...")
            Spacer()
        }
        .background(.blackApp)
    }
}

#Preview {
    HomeView()
}
