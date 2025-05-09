//
//  TimeoutProgressView.swift
//  Movix
//
//  Created by Ancel Dev account on 13/3/25.
//

import SwiftUI

struct TimeoutProgressView: View {
    @State private var showProgress = true
    
    var body: some View {
        Group {
            if showProgress {
                ProgressView()
                    .tint(.marsA)
            } else {
                ZStack {
                    Color.bw20
                        .opacity(0.3)
                    Image(systemName: "photo")
                        .foregroundStyle(.marsA)
                    Image(systemName: "line.diagonal")
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(5))
            withAnimation(.easeIn) {
                showProgress = false
            }
        }
    }
}
#Preview {
    TimeoutProgressView()
}
