//
//  StartView.swift
//  Movix
//
//  Created by Ancel Dev account on 31/10/23.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Image("movix_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 128)
                Text("Welcome to Movix")
                    .hauoraRegular(30)
//                Text("You need to be logged in to use this app.")
            }
            Spacer()
        }
    }
}

#Preview {
    StartView()
}
