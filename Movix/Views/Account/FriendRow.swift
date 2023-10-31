//
//  FriendRow.swift
//  Movix
//
//  Created by Ancel Dev account on 31/10/23.
//

import SwiftUI

struct FriendRow: View {
    
    var body: some View {
        HStack {
            Image("avatarDefault")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48)
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text("Alexandra")
                    .foregroundStyle(.blackWhite)
                    .font(.title3)
                Text("Offline")
                    .foregroundStyle(.textGray)
                    .font(.caption)
            }
            Spacer()
            Button(action: {
                // Invite friend
            }, label: {
                Image(systemName: "person.2.wave.2")
                    .foregroundStyle(.blackWhite)
            })
        }
        .padding()
        .background(.secondBlack)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}

#Preview {
    FriendRow()
}
