//
//  SupportScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 26/3/25.
//

import SwiftUI

struct SupportScreen: View {
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        VStack {
            Text("Support screen")
        }
        .background(.bw10)
        .padding()
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
    SupportScreen()
        .environment(NavigationManager())
}
