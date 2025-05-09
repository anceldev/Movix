//
//  BackButton.swift
//  Movix
//
//  Created by Ancel Dev account on 22/3/25.
//

import SwiftUI

struct BackButton: View {
    
    let label: String?
    
    init(label: String? = nil) {
        self.label = label
    }
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
            if let label {
                Text(label)
            }
        }
//        .foregroundStyle(.blue1)
        .foregroundStyle(.white)
    }
}
