//
//  SupabaseStorageClient+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 21/4/25.
//

import Foundation
import SwiftUI
import Supabase

extension SupabaseStorageClient {
    static var development: SupabaseStorageClient {
        SupabaseClient.development.storage
    }
}
