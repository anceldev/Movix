//
//  MovieService.swift
//  Movix
//
//  Created by Ancel Dev account on 24/10/23.
//

import Foundation

protocol MovieServiceProtocol {
    func details(forMovie id: Movie.ID) async throws -> Movie?
}

class MovieService: MovieServiceProtocol{
    
    private var apiKey = "4bd71d332c3d3c219fe01c8d465ba03a"
    
    func details(forMovie id: Movie.ID) async throws -> Movie? {
        return nil
    }
}
