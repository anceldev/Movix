//
//  PersonalDetailsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 27/3/25.
//

import SwiftUI

struct PersonalDetailsScreen: View {
    @Environment(NavigationManager.self) var navigationManager
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
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    navigationManager.navigateBack()
                } label: {
                    BackButton(label: NSLocalizedString("account-tab-label", comment: "Account tab label"))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonalDetailsScreen()
            .environment(NavigationManager())
    }
}
