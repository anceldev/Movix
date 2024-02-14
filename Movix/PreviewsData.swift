//
//  PreviewsData.swift
//  Movix
//
//  Created by Ancel Dev account on 14/2/24.
//

import Foundation

struct PreviewsData {
    let movie = Movie()
    
    
    func getMovie() -> Movie? {
        if let fileUrl = Bundle.main.url(forResource: "oppenheimer_details", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                let previewMovie = try decoder.decode(Movie.self, from: data)
                return previewMovie
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
