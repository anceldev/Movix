//
//  SearchBarView.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI


struct SearchBarView: View {
    
    let title: String
    @Binding var query: String
    @Binding var debounceQuery: String
    @Binding var showFilterSheet: Bool
    @Binding var viewOption: ViewOption
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.hauora(size: 22, weight: .semibold))
                .foregroundStyle(.white)
            HStack(spacing: 16) {
                SearchField(query: $query, debounceQuery: $debounceQuery)
                SearchBarButtons(showFilterSheet: $showFilterSheet, viewOption: $viewOption)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(.horizontal)
        }
    }
}

