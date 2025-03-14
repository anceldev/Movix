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
    var body: some View {
        NavigationStack {
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
                            //                    case .failure(let _):
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
                            NavigationLink {
                                LanguageScreen()
                                    .environment(userVM)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    Text("Language")
                                        .font(.hauora(size: 16, weight: .medium))
                                    Spacer()
                                    Text(userVM.lang)
                                        .font(.hauora(size: 18, weight: .bold))
                                }
                            }
                            .listRowBackground(Color.bw20)
                            NavigationLink {
                                CountryScreen()
                                    .environment(userVM)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack {
                                    FlagView(countryCode: userVM.country)
                                        .scaledToFit()
                                        .frame(maxWidth: 24)
                                        .clipShape(RoundedRectangle(cornerRadius: 2 ))
                                    Text("Country")
                                        .font(.hauora(size: 16, weight: .medium))
                                    Spacer()
                                    Text(userVM.lang.uppercased())
                                        .font(.hauora(size: 18, weight: .bold))
                                }
                            }
                            .listRowBackground(Color.bw20)
                        } header: {
                            Text("Account settings")
                                .font(.hauora(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                    }
                    .foregroundStyle(.white)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                }
                Button("Logout") {
                    logout()
                }
            }
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
    NavigationStack {
        ProfileScreen()
            .environment(AuthViewModel())
            .environment(UserViewModel(user: User.preview))
    }
}
