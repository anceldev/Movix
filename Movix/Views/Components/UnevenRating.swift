//
//  UnevenRating.swift
//  Movix
//
//  Created by Ancel Dev account on 29/4/25.
//

import SwiftUI

struct UnevenRating: View {
    let rate: String
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .center){
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomTrailing: 10))
                    .fill(.black.opacity(0.8))
                Text(rate)
                    .foregroundStyle(.blue1)
                    .font(.hauora(size: 12))
            }
            .frame(width: 30, height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    UnevenRating(rate: "2")
}
