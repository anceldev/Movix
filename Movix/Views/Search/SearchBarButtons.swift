//
//  SearchBarButtons.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SearchBarButtons: View {
    @Binding var showFilterSheet: Bool
    @Binding var viewOption: ViewOption
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                showFilterSheet.toggle()
            }, label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.white)
            })
            .frame(width: 30)
            Button(action: {
                switch viewOption {
                case .gridx3: viewOption = .gridx2
                case .gridx2: viewOption = .gridx3
                }
            }, label: {
                Group {
                    switch viewOption {
                    case .gridx2: return Image(systemName: "square.grid.3x2.fill")
                    case .gridx3: return Image(systemName: "rectangle.grid.2x2.fill")
                    }
                }
                .foregroundStyle(.white)
            })
            .frame(width: 30)
        }
        .frame(height: 42)
        .padding(.trailing, 16)
    }
}
