//
//  SearchField.swift
//  Movix
//
//  Created by Ancel Dev account on 3/3/25.
//

import SwiftUI

struct SearchField: View {
    @Binding var query: String
    @Binding var debounceQuery: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
                .padding(.leading, 12)
                .padding(.trailing, 4)
            
            TextField("Search...", text: $query, prompt: Text("search-field-placeholder").foregroundStyle(.bw50))
                .tint(Color.bw90)
                .submitLabel(.search)
                .debounced(text: $query, debouncedText: $debounceQuery)
            
            Button(action: {
                query = ""
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
    }
}
