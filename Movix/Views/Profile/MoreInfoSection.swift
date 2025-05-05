//
//  MoreInfoSection.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI

struct MoreInfoSection: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        Button {
            navigationManager.navigate(to: .about)
        } label: {
            HStack {
                Image(.info)
                Text("account-about-label")
                    .font(.hauora(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.bw50)
            }
        }
        .listRowBackground(Color.bw20)
        Button {
            navigationManager.navigate(to: .appCredits)
        } label: {
            HStack {
                Image(.info)
                Text("account-credits-label")
                    .font(.hauora(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.bw50)
            }
        }
        .listRowBackground(Color.bw20)
        
        Button {
            navigationManager.navigate(to: .support)
        } label: {
            HStack {
                Image(.support)
                Text("account-support-label")
                    .font(.hauora(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.bw50)
            }
        }
        .listRowBackground(Color.bw20)
    }
}

