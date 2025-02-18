//
//  UserViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation

@Observable
final class UserViewModel {
    var user: Account
    var errorMessage: String?
    
    init(user: Account) {
        self.user = user
    }
    
//    func getFavoriteMovies() {
//        do {
//            
//        } catch <#pattern#> {
//            <#statements#>
//        }
//    }
    
    func addFavoriteMovie(movie: Movie) async {
        do {
            
        } catch {
            print(error)
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
        }
    }
}
