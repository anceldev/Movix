//
//  SwipeToDismissModifier.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import SwiftUI

struct SwipeToDismissModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    var action: (() -> Void)?
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        if value.translation.width > 80 {
                            if let action {
                                action()
                                dismiss()
                            }
                            else {
                                dismiss()
                            }
                        }
                    })
            )
    }
}

extension View {
    func swipeToDismiss(action: (() -> Void)? = nil) -> some View {
        self.modifier(SwipeToDismissModifier())
    }
}
