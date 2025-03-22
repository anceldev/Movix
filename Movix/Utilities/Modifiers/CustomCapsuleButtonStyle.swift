//
//  CustomCapsuleButtonStyle.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct CustomCapsuleButtonStyle: ButtonStyle {
    enum CapsuleColor {
        case orangeGradient
        case gray
        case lightGray
    }
    
    let color: CapsuleColor
    let height: CGFloat
    let fontSize: CGFloat
    
    var bg: LinearGradient {
        switch color {
        case .orangeGradient:
            LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
        case .gray:
            LinearGradient(colors: [Color.grayM, Color.grayM], startPoint: .bottomLeading, endPoint: .topTrailing)
        case .lightGray:
            LinearGradient(colors: [Color(hex: "#E595957")], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: fontSize))
            .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(bg)
            .clipShape(Capsule())
    }
}

extension ButtonStyle where Self == CustomCapsuleButtonStyle {
    static var capsuleButton: CustomCapsuleButtonStyle { .init(color: .orangeGradient, height: 56, fontSize: 20)}
    static func capsuleButton(_ color: CustomCapsuleButtonStyle.CapsuleColor = .orangeGradient, height: CGFloat = 56, fontSize: CGFloat = 20) -> CustomCapsuleButtonStyle {
        CustomCapsuleButtonStyle(color: color, height: height, fontSize: fontSize)
    }
}
