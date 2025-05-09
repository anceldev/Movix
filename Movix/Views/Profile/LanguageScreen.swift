//
//  LanguageScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 26/2/25.
//

import SwiftUI

struct LanguageScreen: View {

    @State private var selectedLan: String?
    @Environment(UserViewModel.self) var userVM
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        LanguageForm(
            apiLanguages: userVM.languages,
            selectedLan: $selectedLan,
            currentLang: userVM.user.lang,
            action: updateLanguage
        )
    }
    private func updateLanguage() {
        Task {
            await userVM.updateUserLanguage(lang: selectedLan)
            navigationManager.navigateBack()
        }
    }
}

#Preview {
    LanguageScreen()
        .environment(UserViewModel(user: PreviewData.user))
        .environment(NavigationManager())
}
