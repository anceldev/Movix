//
//  NumberFotmatter+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

extension NumberFormatter {
    static var popularity: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 1
        return formatter
    }
}
