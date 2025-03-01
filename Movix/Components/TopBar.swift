//
//  TopBar.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct BannerTopBar: View {
    let backButton: Bool
    let shareButton: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(_ backButton: Bool = true, _ shareButton: Bool = false){
        self.backButton = backButton
        self.shareButton = shareButton
    }
    var body: some View {
        HStack {
            if backButton {
                Button(action: {
                    dismiss()
                }, label: {
                    VStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    .padding(4)
                    .padding(.horizontal, 4)
                })
            }
            Spacer(minLength: 0)
        }
        .opacity(0.8)
        .padding(8)
        .padding(.horizontal)
        .font(.system(size: 20))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
    }
}
//#Preview {
//    BannerTopBar(true)
//        .background(.bw10)
//        .environment(MovieViewModel())
//}
