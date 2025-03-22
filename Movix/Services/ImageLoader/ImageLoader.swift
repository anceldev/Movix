//
//  ImageLoader.swift
//  Movix
//
//  Created by Ancel Dev account on 22/3/25.
//

import Foundation
import SwiftUI

@Observable
final class ImageLoader {
    
    static var shared = ImageLoader()
    
    func loadImage(for path: String?, size: ImageSize) async -> Image? {
        do {
            guard let path else { throw ImageLoaderError.wrongPath }
            if let cacheUiImage = try await ImageCacheManager.shared.getImage(forKey: path) {
                return Image(uiImage: cacheUiImage)
            }
            
            var uiImage: UIImage?
            switch size {
            case .backdrop:
                uiImage = try await getPosterUIImage(for: path)
            case .poster:
                uiImage = try await getPosterUIImage(for: path)
            }
            
            try await ImageCacheManager.shared.saveImage(uiImage!, forKey: path)
            return Image(uiImage: uiImage!)
        } catch {
            setError(error)
            return nil
        }
    }
    
    private func getBackgropImage(for path: String?) async -> Image? {
        guard let path else {
            return nil
        }
        do {
            var url = URL(string: "https://image.tmdb.org/t/p/w780\(path)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/w1280\(path)")!
            let (dataW1280, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW1280) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(path)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            setError(error)
            return nil
        }
    }
    
    private func getPosterImage(for path: String?) async -> Image? {
        guard let path else {
            return nil
        }
        do {
            var url = URL(string: "https://image.tmdb.org/t/p/w780\(path)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
                return Image(uiImage: uiImage)
            }
            url = URL(string: "https://image.tmdb.org/t/p/original\(path)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
                return Image(uiImage: uiImage)
            }
            return nil
        } catch {
            setError(error)
            return nil
        }
    }
    
    private func getPosterUIImage(for path: String?) async throws -> UIImage? {
        guard let path else { return nil }
        do {
            var url = URL(string: "https://image.tmdb.org/t/p/original\(path)")!
            let (dataOriginal, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataOriginal) {
                return uiImage
            }

            url = URL(string: "https://image.tmdb.org/t/p/w780\(path)")!
            let (dataW780, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: dataW780) {
                return uiImage
            }
            throw ImageLoaderError.posterError
        } catch {
            setError(error)
            throw error
        }
    }
    
    private func setError(_ error: Error) {
        print(error)
        print(error.localizedDescription)
    }
    
}
extension ImageLoader {
    enum ImageSize {
        case backdrop
        case poster
    }
    enum ImageLoaderError: Error {
        case posterError
        case backdropError
        case wrongPath
    }
}
