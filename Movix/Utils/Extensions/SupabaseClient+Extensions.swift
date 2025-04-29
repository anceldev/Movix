//
//  SupabaseClient+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 21/4/25.
//

import Foundation
import Supabase

extension SupabaseClient {
    static var development: SupabaseClient {
        SupabaseClient(
            supabaseURL: URL(string: (Bundle.main.infoDictionary?["SUP_PROJECT_URL"] as? String)!)!,
            supabaseKey: (Bundle.main.infoDictionary?["SUP_ANON_KEY"] as? String)!
        )
    }
}
