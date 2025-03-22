//
//  Font+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 16/2/25.
//

import Foundation
import SwiftUI

extension Font {
    static func hauora(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let weightString: String
        switch weight {
        case .bold: weightString = "Bold"
        case .black: weightString = "ExtraBold"
        case .thin: weightString = "ExtraLight"
        case .light: weightString = "Light"
        case .medium: weightString = "Medium"
        case .semibold: weightString = "Semibold"
        default: weightString = "Regular"
        }
        return Font.custom("Hauora-\(weightString)", size: size)
    }
}
