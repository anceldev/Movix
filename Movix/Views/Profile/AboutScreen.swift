//
//  AboutScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 26/3/25.
//

import SwiftUI

struct AboutScreen: View {
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        Text("About screen")
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
    AboutScreen()
        .environment(NavigationManager())
}
