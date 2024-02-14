//
//  FontModifiers.swift
//  Movix
//
//  Created by Ancel Dev account on 6/2/24.
//

import SwiftUI

struct HauoraRegular: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Hauora-Regular", size: size))
    }
}

struct HauroaMedium: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Hauroa-Medium", size: size))
    }
}
struct HauroaBold: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Hauroa-Bold", size: size))
    }
}

// font sizes: 34, 22, 20, 16, 14, 12, 10
extension View {
    func hauoraRegular(_ size: CGFloat = 16) -> some View {
        modifier(HauoraRegular(size: size))
    }
    func hauroaRegular(_ size: CGFloat = 16) -> some View {
        modifier(HauroaMedium(size: size))
    }
    func hauroaBold(_ size: CGFloat = 16) -> some View {
        modifier(HauroaBold(size: size))
    }
}
