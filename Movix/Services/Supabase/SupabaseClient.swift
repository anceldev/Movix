//
//  SupabaseClient.swift
//  Movix
//
//  Created by Ancel Dev account on 15/4/25.
//

import Foundation
import Supabase
import SwiftUI

enum SupabaseTables: String {
    case users
    case friends
}

enum SupabaseConfig: String {
    case projectId
    case anonKey
    case projectUrl
    
    var rawValue: String {
        switch self {
        case .projectId:    Bundle.main.infoDictionary?["SUP_PROJECT_ID"] as? String ?? ""
        case .anonKey:      Bundle.main.infoDictionary?["SUP_ANON_KEY"] as? String ?? ""
        case .projectUrl:   Bundle.main.infoDictionary?["SUP_PROJECT_URL"] as? String ?? ""
        }
    }
}

class SupClient {
    let supabase = SupabaseClient(
        supabaseURL: URL(string: SupabaseConfig.projectUrl.rawValue)!,
        supabaseKey: SupabaseConfig.anonKey.rawValue
    )
    
    func uploadAvatar(userId: UUID, uiImage: UIImage) async throws -> (String, Data) {
        var avatarFileURL: URL? {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
            return documentsDirectory.appendingPathComponent("\(userId.uuidString).jpg")
        }

        guard let resizedImage = uiImage.resizeTo(to: 150),
              let imageData = resizedImage.jpegData(compressionQuality: 0.8)
        else { throw UserViewModelError.avatarCompressionError }
        
        let response = try await supabase.storage
            .from("avatars")
            .update(
                "avatars/\(userId.uuidString)",
                data: imageData,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/jpeg",
                    upsert: false
                )
            )
        
        guard let fileURL = avatarFileURL else { throw UserViewModelError.avatarLocalSaveError }
        try imageData.write(to: fileURL)
    
        return (response.path, imageData)
    }
}

extension SupClient {
    static let shared = SupClient()
}
