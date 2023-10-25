//
//  ButtonViewModifier.swift
//  Movix
//
//  Created by Ancel Dev account on 26/10/23.
//

import SwiftUI

struct ButtonFillViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .padding()
            .background(LinearGradient(colors: [.darkOrange, .lightOrange], startPoint: .leading, endPoint: .trailing))
            .clipShape(Capsule())
    }
}
struct ButtonBorderViewModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .padding()
            .overlay{
                Capsule(style: .continuous)
                    .stroke(color, lineWidth: 1)
            }
    }
}
extension View {
    func buttonFill() -> some View {
        self.modifier(ButtonFillViewModifier())
    }
    func buttonBorder(_ color: Color) -> some View {
        self.modifier(ButtonBorderViewModifier(color: color))
    }
}


