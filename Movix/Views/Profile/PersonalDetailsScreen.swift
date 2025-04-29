//
//  PersonalDetailsScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 27/3/25.
//

import SwiftUI
import PhotosUI

struct PersonalDetailsScreen: View {
    @Environment(NavigationManager.self) var navigationManager
    @Environment(UserViewModel.self) var userVM
    @State private var avatarImage: UIImage?
    @State private var showAvatarPicker = false
    
    var body: some View {
        VStack(alignment: .center) {
            
            if let avatarData = userVM.user.avatarData, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 104, height: 105)
                    .clipShape(.circle)
            }
            
            
            HStack {
                Button {
                    showAvatarPicker.toggle()
                } label: {
                    Text("Select avatar")
                }
            }
            if let avatarImage {
                Image(uiImage: avatarImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(.circle)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.bw10)
        .cropImagePicker(show: $showAvatarPicker, croppedImage: $avatarImage)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    navigationManager.navigateBack()
                } label: {
                    BackButton(label: NSLocalizedString("account-tab-label", comment: "Account tab label"))
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        if let avatarImage {
                            await userVM.updateAvatar(uiImage: avatarImage)
                        }
                    }
                } label: {
                    Text("Guardar")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PersonalDetailsScreen()
            .environment(NavigationManager())
            .environment(UserViewModel(user: PreviewData.user))
    }
}
