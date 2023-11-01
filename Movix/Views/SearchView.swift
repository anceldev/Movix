//
//  SearchView.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//

import SwiftUI

struct SearchView: View {
    
    @State private var queryText = ""
    @StateObject var searchService = SearchService()
    
    private var list = ["Monday", "Tuesday", "Wednesday"]
    private func searchTrending() {
        Task {
            do { try await searchService.searchTrending() }
            catch { fatalError("Can't fetch trending movies") }
        }
    }
    private func search(query: String) {
        Task {
            do { try await searchService.searchMovies(query: query)}
            catch { fatalError("Can't fetch movies from query")}
        }
    }
    var body: some View {
        VStack {
            NavigationView {
            
            List{
                ForEach(searchService.moviesList.results, id: \.id) { result in
                    Text(result.title ?? "No name")
                }
            }
            Spacer()
            }
            .listStyle(.plain)
            .searchable(text: $queryText)
            .onChange(of: queryText) {
                search(query: queryText)
            }
        }
        .background(.blackApp)
        .onAppear(perform: {
            searchTrending()
        })
    }
}

#Preview {
    SearchView()
}
