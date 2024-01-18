//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import SwiftUI

struct ProfileView: View {
    //
    //    private var user = Account.testAccount
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var presentingConfirmationDialog = false
    
    var userProfilePhoto = Image("1")
    
    
    
    let user = User(id: "1", name: "Damaris", email: "dama@mail.com")
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack {
                    VStack(alignment: .center) {
                        PhotoView(image: userProfilePhoto)
                        Text(user.name)
                            .font(.title2)
                            .foregroundStyle(.white)
                        Text(user.email)
                            .foregroundStyle(.textGray)
                    }
                }
                List {
                    Section(header: Text("Account Settings").font(.headline).bold()){
                        NavigationLink {
                            PersonalDetails()
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
                            Text("My devices")
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
                    .listRowBackground(Color.secondBlack)
                    .listRowBackground(Color.secondBlack)
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
                    .listRowBackground(Color.secondBlack)
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
                    .listRowBackground(Color.secondBlack)
                }
                .foregroundStyle(.white)
                .scrollContentBackground(.hidden)
                .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?", isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
                    Button("Delete Account", role: .destructive, action: deleteAccount)
                    Button("Cancel", role: .cancel, action: {})
                }
            }
            .background(.blackApp)
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
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
