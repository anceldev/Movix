//
//  String+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import Foundation

extension String {
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
