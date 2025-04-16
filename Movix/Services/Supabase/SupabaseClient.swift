//
//  SupabaseClient.swift
//  Movix
//
//  Created by Ancel Dev account on 15/4/25.
//

import Foundation
import Supabase

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
}

extension SupClient {
    static let shared = SupClient()
}
