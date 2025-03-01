//
//  ProfileScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ProfileScreen: View {
    @Environment(AuthViewModel.self) var authVM
    @Environment(UserViewModel.self) var userVM
    var body: some View {
//        @Bindable var authVM = authVM
        NavigationStack {
            VStack {
                VStack(spacing: 10) {
                    AsyncImage(url: userVM.user.avatarPathURl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.marsA)
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
                                Text("Language")
                                    .font(.hauora(size: 16, weight: .medium))
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
