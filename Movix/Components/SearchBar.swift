//
//  SearchBar.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI
import Combine

struct SearchBar: View {

    @Binding var searchTerm: String    
    @Binding var viewOption: ViewOption
    @Binding var showFilter: Bool
    let action: () async -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            HStack {
                Button {
                    searchAction()
//                    await action()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                        .padding(.leading, 12)
                        .padding(.trailing, 4)
                }
                TextField("Search...", text: $searchTerm, prompt: Text("Search...").foregroundStyle(.bw50))
                    .tint(Color.bw90)
                    .submitLabel(.search)
                    .onSubmit {
//                        searchAction()
                    }
                
                Button(action: {
                    searchTerm = ""
                }, label: {
                    Label("Clear", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.bw50)
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: 44)
            .background(.bw40)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.leading, 16)
            HStack(spacing: 8) {
                Button(action: {
                    showFilter.toggle()
                }, label: {
                    Label("Filter", systemImage: "line.3.horizontal.decrease")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.white)
                })
                Button(action: {
                    switch viewOption {
                    case .row: viewOption = .gridx2
                    case .gridx2: viewOption = .gridx3
                    case .gridx3: viewOption = .row
                    }
                }, label: {
                    Group {
                        switch viewOption {
                        case .row: return Image(systemName: "rectangle.grid.1x2.fill")
                        case .gridx2: return Image(systemName: "rectangle.grid.2x2.fill")
                        case .gridx3: return Image(systemName: "square.grid.3x2.fill")
                        }
                    }
                    .foregroundStyle(.white)
                })
            }
            .frame(height: 42)
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
    private func searchAction() {
        Task {
            await action()
        }
    }
//    private func searchAction() {
//        print("Tapped")
//        Task {
//            await action()
//        }
//    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    @Previewable @State var viewOption: ViewOption = .row
    SearchBar(searchTerm: .constant(""), viewOption: $viewOption, showFilter: .constant(false)) {
        print("Searching...")
    }
    .background(.bw20)        
})
