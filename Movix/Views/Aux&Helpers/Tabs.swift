//
//  Tabs.swift
//  Movix
//
//  Created by Ancel Dev account on 6/2/24.
//

import SwiftUI

struct TabsViewModifier: ViewModifier {
    let nameImage: String

    func body(content: Content) -> some View {
        content
            .tabItem { Image(nameImage) }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.blackApp, for: .tabBar)
    }
}

extension View {
    func mainTabView(image: String) -> some View {
        modifier(TabsViewModifier(nameImage: image))
    }
}
