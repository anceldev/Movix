//
//  HomeView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    
    private var genres = ["Action", "Adventure", "Drama", "Comedy"]
    
    @State var queryText = ""
    
    init() {
        let colorAppeareance = UINavigationBarAppearance()
        colorAppeareance.configureWithOpaqueBackground()
        colorAppeareance.backgroundColor = .blackApp
        colorAppeareance.titleTextAttributes = [.foregroundColor: UIColor.blackWhite]
        colorAppeareance.largeTitleTextAttributes = [.foregroundColor: UIColor.blackWhite]
        
        UINavigationBar.appearance().standardAppearance = colorAppeareance
        UINavigationBar.appearance().compactAppearance = colorAppeareance
        UINavigationBar.appearance().scrollEdgeAppearance = colorAppeareance
        
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        NavigationStack {
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
                List {
                    
                }
                .searchable(text: $queryText)
                .listStyle(.plain)
                //.background(.blackApp)
                //.scrollContentBackground(.hidden)
            }
            .background(.blackApp)
            .navigationTitle("Catalog")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundStyle(.blackWhite)
        }
        
        
        
        /*VStack {
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
                Text("Hi")
                /*List(genres, id: \.self){ genre in
                    if( searchText.isEmpty || genre.contains(searchText)) {
                        Text(genre)
                    }
                }
                
                .listStyle(.plain)

                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.blackApp)
                .foregroundStyle(.blackWhite)
                .font(.title2)
                .multilineTextAlignment(.center)*/
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search...")
            Spacer()
        }
        .background(.blackApp)*/
    }
}

#Preview {
    HomeView()
}
