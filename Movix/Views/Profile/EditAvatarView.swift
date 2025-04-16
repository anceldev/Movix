//
//  EditAvatarView.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import SwiftUI

struct EditAvatarView: View {
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    let avatarPath: String?
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                if let newImage = croppedImage {
                    Image(uiImage: newImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(.circle)
                        .overlay {
                            Circle().stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 5)
                        }
                    
                    
                } else {
                    if let avatarPath = avatarPath {
                        AsyncImage(url: URL(string: avatarPath)!) { phase in
                            switch phase {
                            case .empty:
                                Image(.profileDefault)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .clipShape(.circle)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .clipShape(.circle)
                            case .failure:
                                Text("No image founded")
                            @unknown default:
                                Image(.profileDefault)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            }
                        }
                    }
                    else {
                        Image(.profileDefault)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            Spacer()
            Button {
                print("Saving image...")
            } label: {
                Text("save-button-label")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.capsuleButton)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    print("Go back...")
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showPicker.toggle()
                } label: {
                    Text("Edit")
                        .foregroundStyle(.blue1)
                }
            }
        }
        .cropImagePicker(show: $showPicker, croppedImage: $croppedImage)
    }
}

#Preview {
    NavigationStack {
        EditAvatarView(avatarPath: nil)
    }
}
