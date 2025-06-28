//
//  AvatarField.swift
//  Movix
//
//  Created by Ancel Dev account on 26/6/25.
//

import SwiftUI

struct AvatarField: View {
    
    @State private var showAvatarPicker = false
    @Binding var avatar: UIImage?
    var flow: AuthFlow
    
    var body: some View {
        VStack(spacing: 36) {
            VStack {
                Group {
                    if let avatar = avatar {
                        Image(uiImage: avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay {
                                Circle().stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                            }
                    } else {
                        VStack(spacing: 12) {
                            Image("profileDefault")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 80)
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showAvatarPicker.toggle()
                } label: {
                    Image(systemName: "photo")
                        .font(.system(size: 10))
                        .padding(6)
                        .background(.bw10)
                        .clipShape(.circle)
                        .foregroundStyle(.white)
                        .overlay {
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        }
                }
                .disabled(flow != .preferences)
                .opacity(flow != .preferences ? 0 : 1)
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .cropImagePicker(show: $showAvatarPicker, croppedImage: $avatar)
    }
}
