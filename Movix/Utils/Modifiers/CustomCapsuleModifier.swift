//
//  CustomCapsuleModifier.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct CustomCapsuleViewModifier: ViewModifier {
    let stroke: Color
    let input: Bool
    let bg: Color
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: input ? .leading : .center)
            .padding(.leading, input ? 20 : 0)
            .frame(height: 56)
            .foregroundStyle(.white)
            .font(.system(size: input ? 17 : 20, weight: input ? .regular : .medium))
            .background(bg)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(input ? stroke : .white, lineWidth: 1)
            }
    }
}


extension View {
    func customCapsule(_ stroke: Color, input: Bool = false, bg: Color = .black) -> some View {
        modifier(CustomCapsuleViewModifier(stroke: stroke, input: input, bg: bg))
    }
}
