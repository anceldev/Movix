//
//  SearchField.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchTerm: String
    let loadAction: () async -> Void
    let clearAction: () -> Void
    
    var body: some View {
//        HStack(spacing: 16) {
            HStack {
                Button {
                    searchAction()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                        .padding(.leading, 12)
                        .padding(.trailing, 4)
                }
                TextField("Search...", text: $searchTerm, prompt: Text("search-field-placeholder").foregroundStyle(.bw50))
                    .tint(Color.bw90)
                    .submitLabel(.search)
                    .onSubmit {
                        searchAction()
                    }
                Button(action: {
                    searchTerm = ""
                    clearAction()
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
//            .padding(.leading, 16)
    }
    private func searchAction() {
        Task {
            await loadAction()
        }
    }
}

#Preview {
    SearchField(searchTerm: .constant(""), loadAction: {}, clearAction: {})
}
