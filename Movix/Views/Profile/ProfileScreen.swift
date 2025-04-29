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
    
    var body: some View {
        @Bindable var navigationManager = navigationManager
        VStack {
            VStack(spacing: 10) {
                if let avatarData = userVM.user.avatarData, let uiImage = UIImage(data: avatarData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 104, height: 105)
                        .clipShape(.circle)
                        .overlay {
                            Circle().stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                        }
                } else {
                    Image(.profileDefault)
                        .resizable()
                        .frame(width: 104, height: 104)
                }
                Text(userVM.user.username)
                    .font(.hauora(size: 20))
                    .foregroundStyle(.white)
            }
            .animation(.easeIn, value: userVM.user.avatarData)
            VStack {
                List {
                    Section {
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
                        
                        Button {
                            navigationManager.navigate(to: .friends)
                        } label: {
                            HStack {
                                Image(.friends)
                                Text("account-friends-label")
                                    .font(.hauora(size: 16, weight: .medium))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.bw50)
                            }
                        }
                        .listRowBackground(Color.bw20)
                        
                        Button {
                            navigationManager.navigate(to: .languages)
                        } label: {
                            HStack {
                                Image(systemName: "translate")
                                Text("account-language-label")
                                    .font(.hauora(size: 16, weight: .medium))
                                Spacer()
                                Text(userVM.user.lang)
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
                                FlagView(countryCode: userVM.user.country)
                                    .scaledToFit()
                                    .frame(maxWidth: 24)
                                    .clipShape(RoundedRectangle(cornerRadius: 2 ))
                                Text("account-country-label")
                                    .font(.hauora(size: 16, weight: .medium))
                                Spacer()
                                Text(userVM.user.country.uppercased())
                                    .font(.hauora(size: 18, weight: .bold))
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.bw50)
                            }
                        }
                        .listRowBackground(Color.bw20)
                    } header: {
                        Text("account-section-settings-label")
                            .font(.hauora(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    
                    Section {
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
                            navigationManager.navigate(to: .aboutTMDB)
                        } label: {
                            HStack {
                                Image(.info)
                                Text("account-about-tmdb-label")
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
