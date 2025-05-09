//
//  LanguageRow.swift
//  Movix
//
//  Created by Ancel Dev account on 7/5/25.
//

import SwiftUI

struct LanguageRow: View {
    let lang: Language
    @Binding var selected: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(lang.englishName)
                .font(.hauora(size: 16))
                .foregroundStyle(selected == lang.iso6391 ? .white : .bw50)
            Spacer(minLength: 0)
            if selected == lang.iso6391 {
                Image(systemName: "checkmark")
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                    .font(.system(size: 8))
                    .padding(6)
                    .background(.linearGradient(colors: [.marsA, .marsB], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .clipShape(.circle)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(selected == lang.iso6391 ? .filtersBackground : .bw10)
    }
}
