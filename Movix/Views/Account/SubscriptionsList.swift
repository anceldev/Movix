//
//  SubscriptionsList.swift
//  Movix
//
//  Created by Ancel Dev account on 31/10/23.
//

import SwiftUI

struct SubscriptionsList: View {
    var body: some View {
        Section(header: Text("Subscriptions").font(.subheadline).bold()){
            NavigationLink {
                Text("Payment")
            } label: {
                Image(systemName: "creditcard")
                Text("Payment")
            }
            NavigationLink {
                Text("Checks")
            } label: {
                Image(systemName: "newspaper")
                Text("Checks")
            }
        }
        .listRowBackground(Color.secondBlack)
    }
}

#Preview {
    SubscriptionsList()
}
