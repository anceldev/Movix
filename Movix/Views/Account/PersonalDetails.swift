//
//  PersonalDetails.swift
//  Movix
//
//  Created by Ancel Dev account on 23/10/23.
//

import SwiftUI

struct PersonalDetails: View {
    @Environment(UserViewModel.self) var userViewModel

    @State private var selectedUIImage: UIImage?
    @State var image: Image?
    @State private var showImagePicker = false
    @State private var editMode = false
    @State private var newName = ""
    
    var body: some View {
        
        NavigationStack {
            VStack{
                Spacer()
                ZStack {
                    if let image = image {
                        PhotoView(image: image, size: 200)
                    } else {
                        PhotoView(size: 200)
                    }
                    if editMode {
                        Button("Update"){
                            showImagePicker.toggle()
                        }
                        .sheet(isPresented: $showImagePicker, onDismiss: {
                            loadImage()
                        }) {
                            ImagePicker(image: $selectedUIImage)
                        }
                    }
                }
                VStack {
                    VStack {
                        TextField(text: $newName) {
                            Text(editMode ? "New name " :  userViewModel.user.name)
                                .foregroundStyle(.grayLight)
                            
                        }
                        .foregroundStyle(.grayLight)
                        .disabled(!editMode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .multilineTextAlignment(.center)
                    }
                    .buttonBorder( editMode ? .grayLight : .blackApp)
                    .padding()
                }
                .padding()
                if editMode {
                    Button(action: {
                        saveChanges()
                    }, label: {
                        Text("Save")
                    })
                    .frame(minWidth: 150)
                    .buttonFill()
                }
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.blackApp)
            .toolbar {
                Toggle(isOn: $editMode.animation(), label: {
                    Text("Edit")
                })
            }
        }
        .onAppear {
            self.image = userViewModel.profileImage
        }
    }
    private func saveChanges() {
        updateProfileImage()
        if !newName.isEmpty {
            userViewModel.userNameChange(username: newName) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    userViewModel.user.name = newName
                    withAnimation {
                        editMode = false
                    }
                }
            }
        }
    }
    private func updateProfileImage() {
        guard let uiImage = selectedUIImage else { return }
        userViewModel.profileImage = Image(uiImage: uiImage)
        if userViewModel.updateAvatar(image: uiImage, uidUser: userViewModel.user.id!) {
            print("Image updated")
        } else {
            print("Cannot update image")
        }
    }
    private func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        image = Image(uiImage: selectedImage)
    }
}

#Preview {
    PersonalDetails()
        .environment(UserViewModel(uidUser: "eMFzFzG9p0aamFiCu1Vm1j1MvrwF"))
}
