//
//  StorageClientKey.swift
//  Movix
//
//  Created by Ancel Dev account on 21/4/25.
//

import Foundation
import SwiftUI
import Supabase


struct StorageKey: EnvironmentKey {
    static let defaultValue: SupabaseStorageClient = SupClient.shared.supabase.storage
}

extension EnvironmentValues {
    var storageClient: SupabaseStorageClient {
        get { self[StorageKey.self] }
        set { self[StorageKey.self] = newValue }
    }
}
