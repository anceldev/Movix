//
//  MoviesViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import Foundation

@Observable
class MoviesViewModel {
    
    var movies = [Movie]()
    
    func details(forMovie: Movie){
        
        /*var data: [String: String] {
            var dictionary = [String:String]()
            
            var countries = ""
            movie.productionCountries?.forEach { country in countries += "\(country.name) "}
            dictionary["Country"] = "\(countries)"
            
            let calendar = Calendar.current
            let year = calendar.component(.year, from: movie.date)
            dictionary["Production year"] = "\(year)"
            dictionary["Film budget"] = String(describing: movie.budget)
            dictionary["Age"] = (movie.adult! ? "+18" : "NS")
            
            var minutes = movie.runtime!
            var time = "\(minutes) min/ "
            
            let hours = minutes / 60
            minutes = minutes % 60
            time += "\(hours)h \(minutes)min"
            dictionary["Time"] = time
            
            return dictionary
        }*/
    }

}
