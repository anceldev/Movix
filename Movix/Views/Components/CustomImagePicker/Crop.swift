//
//  Crop.swift
//  Memories
//
//  Created by Ancel Dev account on 29/11/24.
//

import SwiftUI

enum Crop: Equatable {
    case circle
    case rectangle
    case square
    case vRectangle
    case custom(CGSize)
    
    func name() -> String {
        switch self {
        case .circle: "Circle"
        case .rectangle: "Rectangle"
        case .square: "Square"
        case .vRectangle: "Vertical Rectangle"
        case .custom(let cGSize): "Custom \(cGSize.width) x \(cGSize.height)"
        }
    }
    
    func size() -> CGSize {
        switch self {
        case .circle: .init(width: 300, height: 300)
        case .rectangle: .init(width: 300, height: 169)
        case .square: .init(width: 300, height: 300)
        case .vRectangle: .init(width: 500, height: 300)
        case .custom(let cGSize): cGSize
        }
    }
}
