//
//  MovieResult.swift
//  Movix
//
//  Created by Ancel Dev account on 1/11/23.
//
import Foundation
import SwiftUI

struct MovieResult: View {
    @State var movie: Movie
    var urlImage: URL
    
    
    
    /*var urlImage: URL {
        //let urlString = "https://image.tmdb.org/t/p/" + "w185" + (movie.posterPath ?? "")
        let urlString = "https://image.tmdb.org/t/p/" + "w300" + (movie.backdropPath ?? "")
        Task {
            do {
                let (_, response) = try await URLSession.shared.data(from: URL(string: urlString)!)
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw UFDError.reponseFailed
                }
            }
            catch {
                print("Error getting image")
            }
        }
        return URL(string: urlString)!
    }*/
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                AsyncImage(url: urlImage) { phase in
                    switch phase {
                    case .empty:
                        Text("No Image")
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                    case .failure(_):
                        ProgressView()
                            .frame(width: 136, height: 88)
                    @unknown default:
                        Text("Unknown Error in image")
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(movie.title!)
                    .foregroundStyle(.blackWhite)
                    .font(.title3)
                Text(movie.releaseDate!)
                    .foregroundStyle(.textGray)
            }
            .padding(.top, 10)
            Spacer()
        }
        .frame(height: 88)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.blackApp)
    }
}

#Preview {
    MovieResult(movie: Movie.test, urlImage: URL(string: "https://image.tmdb.org/t/p/w300/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg")!)
}
