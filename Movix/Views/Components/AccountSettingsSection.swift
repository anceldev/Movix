//
//  AccountSettingsSection.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI
import FlagsKit


struct AccountSettingsSection: View {
    
    @Environment(NavigationManager.self) var navigationManager
    let country: String
    let lang: String
    var body: some View {
        
        Button {
            navigationManager.navigate(to: .personalDetails)
        } label: {
            HStack {
                Image(.personalDetails)
                Text("account-personal-details-label")
                    .font(.hauora(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.bw50)
            }
        }
        .listRowBackground(Color.bw20)
        
//        Button {
//            navigationManager.navigate(to: .friends)
//        } label: {
//            HStack {
//                Image(.friends)
//                Text("account-friends-label")
//                    .font(.hauora(size: 16, weight: .medium))
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .foregroundStyle(.bw50)
//            }
//        }
//        .listRowBackground(Color.bw20)
        
        Button {
            navigationManager.navigate(to: .languages)
        } label: {
            HStack {
                Image(systemName: "translate")
                Text("account-language-label")
                    .font(.hauora(size: 16, weight: .medium))
                Spacer()
                Text(lang)
                    .font(.hauora(size: 18, weight: .bold))
                Image(systemName: "chevron.right")
                    .foregroundStyle(.bw50)
            }
        }
        .listRowBackground(Color.bw20)
        
        Button {
            navigationManager.navigate(to: .countries)
        } label: {
            HStack {
                FlagView(countryCode: country)
                    .scaledToFit()
                    .frame(maxWidth: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 2 ))
                Text("account-country-label")
                    .font(.hauora(size: 16, weight: .medium))
                Spacer()
                Text(country.uppercased())
                    .font(.hauora(size: 18, weight: .bold))
                Image(systemName: "chevron.right")
                    .foregroundStyle(.bw50)
            }
        }
        .listRowBackground(Color.bw20)
    }
}

#Preview {
    AccountSettingsSection(country: "es", lang: "es")
        .environment(NavigationManager())
}
