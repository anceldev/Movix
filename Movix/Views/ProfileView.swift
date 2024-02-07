//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(UserViewModel.self) var userViewModel
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
        
    var body: some View {
        NavigationStack{
            VStack{
                HStack {
                    VStack(alignment: .center) {
                        ZStack {
                            if let image = userViewModel.profileImage {
                                PhotoView(image: image)
                            } else {
                                PhotoView()
                            }
                        }
                        Text(userViewModel.user.name)
                            .font(.title2)
                            .foregroundStyle(.white)
                        Text(userViewModel.user.email)
                            .foregroundStyle(.grayLight)
                    }
                }
                List {
                    Section(header: Text("Account Settings").font(.headline).bold()){
                        NavigationLink {
                            PersonalDetails()
                                .environment(userViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "square.and.pencil")
                                Text("Personal details")
                            }
                        }
                        NavigationLink{
                            FriendsList()
                        } label: {
                            Image(systemName: "person.2")
                            Text("Friends")
                        }
                        NavigationLink {
                            Text("Notifications")
                        } label: {
                            Image(systemName: "bell")
                            Text("Notifications")
                        }
                        NavigationLink {
                            Text("Recomendations")
                        } label: {
                            Image(systemName: "heart")
                            Text("Recomendations")
                        }
                        NavigationLink {
                            Text("History")
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                            Text("History")
                        }
                    }
                    .listRowBackground(Color.grayExtraBold)
                    Section(header: Text("More info and support").font(.headline).bold()) {
                        NavigationLink {
                            Text("Support")
                        } label: {
                            Image(systemName: "lifepreserver")
                            Text("Support")
                        }
                        NavigationLink {
                            Text("Info")
                        } label: {
                            Image(systemName: "info.circle")
                            Text("About")
                        }
                    }
                    .listRowBackground(Color.grayExtraBold)
                    Section("Exit"){
                        Button(role: .cancel , action: {
                            viewModel.reset()
                            signOut()
                        }, label: {
                            Text("Sign Out")
                                .foregroundStyle(.darkOrange)
                        })
                        Button(role: .destructive, action: { presentingConfirmationDialog.toggle()}) {
                            Text("Delete Account")
                                .foregroundStyle(.red)
                        }
                    }
                    .listRowBackground(Color.grayExtraBold)
                }
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?", isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
                    Button("Delete Account", role: .destructive, action: deleteAccount)
                    Button("Cancel", role: .cancel, action: {})
                }
            }
            .background(.blackApp)
            .toolbarBackground(Color.blackApp, for: .tabBar)
        }
    }
    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
    private func signOut() {
        viewModel.signOut()
    }
}

#Preview {
    let user = User(id: "1", name: "Damaris", email: "dama@mail.com", friends: [], history: [], settings: nil)
    return ProfileView()
        .environmentObject(AuthenticationViewModel())
        .environment(UserViewModel(uidUser: "eMFzFzG9p0aamFiCu1Vm1j1MvrwF"))
}
