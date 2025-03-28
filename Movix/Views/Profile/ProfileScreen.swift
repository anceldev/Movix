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
        NavigationStack(path: $navigationManager.path) {
            VStack {
                VStack(spacing: 10) {
                    AsyncImage(url: userVM.user.avatarPathURl, transaction: Transaction(animation: .easeIn(duration: 0.5))) { phase in
                        switch phase {
                        case .empty:
                                Image(.profileDefault)
                                    .resizable()
                                    .frame(width: 104, height: 104)
                        case .success(let image):
                            ZStack {
                                Color.bw50
                                    .frame(width: 104, height: 104)
                                    .clipShape(.circle)
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 104, height: 104)
                                    .overlay {
                                        Circle().stroke(.marsA, lineWidth: 2)
                                    }
                            }
                        case .failure:
                            Image(.profileDefault)
                                .resizable()
                                .frame(width: 104, height: 104)
                        @unknown default:
                            Image(.profileDefault)
                                .resizable()
                                .frame(width: 104, height: 104)
                        }
                    }
                    .padding(.top, 20)
                    Text(userVM.user.username)
                        .font(.hauora(size: 20))
                        .foregroundStyle(.white)
                }
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
                                navigationManager.navigate(to: .languages)
                            } label: {
                                HStack {
                                    Image(systemName: "translate")
                                    Text("account-language-label")
                                        .font(.hauora(size: 16, weight: .medium))
                                    Spacer()
                                    Text(userVM.lang)
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
                                    FlagView(countryCode: userVM.country)
                                        .scaledToFit()
                                        .frame(maxWidth: 24)
                                        .clipShape(RoundedRectangle(cornerRadius: 2 ))
                                    Text("account-country-label")
                                        .font(.hauora(size: 16, weight: .medium))
                                    Spacer()
                                    Text(userVM.lang.uppercased())
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

                        
                    }
                    .foregroundStyle(.white)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                }
                Button("signout-button-label") {
                    logout()
                }
            }
            .withAppRouter()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.bw10)
            .onAppear {
            }
        }
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
            .environment(UserViewModel(user: User.preview))
            .environment(navManager)
    }
}
