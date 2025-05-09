//
//  CountryScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 13/3/25.
//

import SwiftUI
import FlagsKit

struct CountryScreen: View {
    @Environment(UserViewModel.self) var userVM
    @Environment(NavigationManager.self) var navigationManager
    
    @State private var selectedCountry: String?
    
    var body: some View {
        CountryForm(
            apiCountries: userVM.countries,
            selectedCountry: $selectedCountry,
            currentCountry: userVM.user.country,
            action: updateCountry
        )
    }
    private func updateCountry() {
        Task {
            await userVM.updateUserCountry(country: selectedCountry)
            navigationManager.navigateBack()
        }
    }
}

#Preview {
    CountryScreen()
        .environment(UserViewModel(user: PreviewData.user))
        .environment(NavigationManager())
}
