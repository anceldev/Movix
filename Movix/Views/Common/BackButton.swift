//
//  BackButton.swift
//  Movix
//
//  Created by Ancel Dev account on 22/3/25.
//

import SwiftUI

struct BackButton<Content:View>: View {
    
//    let label: String?
    let content: (() -> Content)?
    
//    init(label: String?, content: @escaping () -> Content) {
//        self.label = label
//        self.content = content
//    }
    
    init(content: (() -> Content)? = nil) {
        self.content = content
    }
    
//    init(content: @escaping () -> Content = nil) {
//        self.content = content
//    }
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
            if let content {
//                Text(label)
                content()
            }
        }
        .foregroundStyle(.blue1)
    }
}
