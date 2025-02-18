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
        VStack {
            Text("Profile screen")
                .foregroundStyle(.white)
            VStack {
//                if let user = authVM.user {
//                    ForEach(user.movies, id:\.id) { movie in
//                        Text(movie.movieId, format: .number)
//                    }
//                    
//                }
//                ForEach(userVM.user.movies) { movie in
//                    Text(movie.movieId, format: .number)
//                }
            }
            Button("Logout") {
                logout()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
    private func logout() {
        Task {
            await authVM.signOut()
        }
    }
}

#Preview {
    ProfileScreen()
        .environment(AuthViewModel())
        .environment(UserViewModel(user: Account.preview))
}
