//
//  ProvidersScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ProvidersScreen: View {

    @Environment(\.dismiss) private var dismiss
    let mediaType: MediaType
    @State private var providersVM: ProvidersViewModel
    
    init(mediaId: Int, mediaType: MediaType) {
        self.mediaType = mediaType
        self._providersVM = State(initialValue: ProvidersViewModel(mediaType: mediaType, mediaId: mediaId))
    }
//    var providers: Providers? 

    var body: some View {
        VStack {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Providers")
                            .font(.hauora(size: 32, weight: .medium))
                        ProvidersList(title: "Stream", providers: providersVM.providers.streamProviders)
                            .background(.clear)
                        ProvidersList(title: "Rent", providers: providersVM.providers.rentProviders)
                            .background(.clear)
                        ProvidersList(title: "Buy", providers: providersVM.providers.buyProviders)
                            .background(.clear)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                }
                .scrollIndicators(.hidden)
        }
        .background(.bw10)
        .frame(maxHeight: .infinity)
        .swipeToDismiss()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(mediaType == .movie ? "Movie" : "Serie")
                    }
                    .foregroundStyle(.blue1)
                }
            }
        }
    }
    @ViewBuilder
    func ProvidersList(title: String, providers: [Providers.Provider]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.hauora(size: 20, weight: .medium))
                .foregroundStyle(.bw50)
            if providers.count > 0 {
                FlowLayout(spacing: 24) {
                    ForEach(providers) { provider in
                        ZStack {
                            AsyncImage(url: provider.logoPath) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 75, height: 75, alignment: .top)
                                case .failure:
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                @unknown default:
                                    ProgressView()
                                }
                            }
                        }
                        .background(content: {
                            LinearGradient(colors: [.bw50, .bw90], startPoint: .top, endPoint: .bottom)
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .frame(width: 75, height: 75)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .scrollIndicators(.hidden)
            } else {
                Text("No available \(title.lowercased()) providers in your region")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 16)
            }
        }
    }
}
