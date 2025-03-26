//
//  PersonalDetailsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 27/3/25.
//

import SwiftUI

struct PersonalDetailsScreen: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("account-personal-details-text")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            Link(destination: URL(string:"https://www.themoviedb.org")!) {
                Image(.tmdbLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 180)
            }
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.bw10)
    }
}

#Preview {
    NavigationStack {
        PersonalDetailsScreen()        
    }
}
