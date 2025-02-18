//
//  MovieActionsBar.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ActionBarButtonLabel: View {
    let label: String
    let imageName: String
    let isOn: Bool
    
    var image: Image {
        if isOn {
            return Image(imageName)
        }
        else {
            return Image("\(imageName)-disabled")
        }
    }
    var body: some View {
        VStack(spacing: 12) {
            VStack {
                image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(isOn ? .blue1 : .bw50)
            }
            .frame(width: 30, height: 30)
            Text(label)
                .font(.hauora(size: 12))
                .foregroundStyle(isOn ? .blue1 : .bw50)
        }
        .frame(width: 60)
    }
}

struct MovieActionsBar: View {
    let idMovie: Int
    @Binding var showRateSlider: Bool
    @Environment(MovieViewModel.self) var movieVM
    @Environment(UserViewModel.self) var userVM

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button(action: {
                    showRateSlider.toggle()
                }, label: {
                    ActionBarButtonLabel(label: "Rate", imageName: "rate", isOn: false)
                })
                
                Button(action: {
                    print("My list")
                }, label: {
                    ActionBarButtonLabel(label: "Favorites", imageName: "heart-icon", isOn: true)
                })
                Button(action: {
                    print("My list")
                }, label: {
                    ActionBarButtonLabel(label: "My List", imageName: "heart-icon", isOn: false)
                })
                NavigationLink {
                    ProvidersScreen()
                        .navigationBarBackButtonHidden()
                        .environment(movieVM)
                } label: {
                    VStack(spacing: 12) {
                        VStack {
                            Image(.providersIcon)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(8)
                                .background(
                                    LinearGradient(colors: [Color.marsA, Color.marsB], startPoint: .bottomLeading, endPoint: .topTrailing)
                                )
                                .clipShape(.circle)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 30, height: 30)
                        Text("Providers")
                            .font(.hauora(size: 12))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 60)
                }
            }
            .padding(.top, 26)
        }
        .frame(maxWidth: .infinity)
        .background(.bw10)
    }
}

#Preview {
    MovieActionsBar(idMovie: 533535, showRateSlider: .constant(true))
        .background(.bw20)
        .environment(MovieViewModel())
        .environment(UserViewModel(user: Account.preview))
}

