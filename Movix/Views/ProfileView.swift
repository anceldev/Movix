//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import SwiftUI

struct ProfileView: View {
    
    private var user = Account.testAccount
    
    var body: some View {
        NavigationStack{
            VStack {
                PhotoView(image: user.profileImage)
                Text(user.details.name)
                    .font(.title2)
                    .foregroundStyle(.white)
                Text(user.details.email)
                    .foregroundStyle(.textGray)
                VStack{
                    List {
                        Section(header: Text("Account Settings").font(.subheadline).bold()){
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
                                Image(systemName: "macbook.and.iphone")
                                Text("My devices")
                            }
                            NavigationLink {
                                Text("History")
                            } label: {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("History")
                            }
                        }
                        .listRowBackground(Color.secondBlack)
                        
                        Section(header: Text("Subscriptions").font(.subheadline).bold()){
                            NavigationLink {
                                Text("Payment")
                            } label: {
                                Image(systemName: "creditcard")
                                Text("Payment")
                            }
                            NavigationLink {
                                Text("Checks")
                            } label: {
                                Image(systemName: "newspaper")
                                Text("Checks")
                            }
                        }
                        .listRowBackground(Color.secondBlack)
                        Section(header: Text("More info and support").font(.subheadline).bold()) {
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
                    }
                    .foregroundStyle(.white)
                    
                    .scrollContentBackground(.hidden)
                }
            }
            .background(.blackApp)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProfileView()
}
