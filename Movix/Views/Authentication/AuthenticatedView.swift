//
//  AuthenticatedView.swift
//  Movix
//
//  Created by Ancel Dev account on 25/10/23.
//

import SwiftUI

// see https://michael-ginn.medium.com/creating-optional-viewbuilder-parameters-in-swiftui-views-a0d4e3e1a0aeextension AuthenticatedView where Unauthenticated == EmptyView {
extension AuthenticatedView where Unauthenticated == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = nil
        self.content = content
    }
}

struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    @State private var presentingLoginScreen = false
    @State private var presentingHomeView = false
    
    var unauthenticated: Unauthenticated?
    @ViewBuilder var content: () -> Content
    
    public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated
        self.content = content
    }
    
    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated()
        self.content = content
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                switch viewModel.authenticationState {
                case .unauthenticated, .authenticating:
                    VStack{
                        Spacer()
                        if let unauthenticated {
                            unauthenticated
                        }
                        else {
                            Text("You are not logged in.")
                        }
                        Button(action: {
                            viewModel.reset()
                            presentingLoginScreen.toggle()
                        }, label: {
                            Text("Tap here to log in")
                                .bold()
                                .padding(.top)
                        })
                        Spacer()
                    }
                    .sheet(isPresented: $presentingLoginScreen, content: {
                        AuthenticationView()
                            .environmentObject(viewModel)
                    })
                case .authenticated:
                    MainTabView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}

#Preview {
    AuthenticatedView{
        Text("You're signed in.")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(.yellow)
    }
}
