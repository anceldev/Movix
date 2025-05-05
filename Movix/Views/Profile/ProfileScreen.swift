//
//  ProfileScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI
import FlagsKit

struct ProfileScreen: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(UserViewModel.self) var userVM
    @Environment(NavigationManager.self) var navigationManager
    
    @State private var showLanguageScreen = false
    @State private var showCountryScreen = false
    
    var body: some View {
        @Bindable var navigationManager = navigationManager
        VStack(spacing: 0) {
            ProfileAvatarView(avatarData: userVM.user.avatarData, username: userVM.user.username)
                .padding(.top, 20)
            VStack {
                List {
                    Section {
                        AccountSettingsSection(country: userVM.user.country, lang: userVM.user.lang)
                    } header: {
                        Text("account-section-settings-label")
                            .font(.hauora(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Section {
                        MoreInfoSection()
                    } header: {
                        Text("account-section-info-label")
                            .font(.hauora(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Section {
                        Button("signout-button-label") {
                            logout()
                        }
                        .listRowBackground(Color.bw20)
                        .foregroundStyle(.blue1)
                    }
                }
                .foregroundStyle(.white)
                .background(.clear)
                .scrollContentBackground(.hidden)
            }
        }
        .withAppRouter()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .onAppear {
        }
        .environment(userVM)
    }
    private func logout() {
        Task {
            await authVM.signOut()
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManager()
    NavigationStack(path: $navManager.path) {
        ProfileScreen()
            .environment(AuthViewModel())
            .environment(UserViewModel(user: PreviewData.user))
            .environment(navManager)
    }
}
