//
//  ActorScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ActorScreen: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = PeopleViewModel()
    @State private var viewMoreLimit: Int? = 5
    let id: Int
    
    init(id: Int) {
        self.id = id
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                ZStack(alignment: .top) {
                    ActorPhoto()
                    LinearGradient(
                        stops: [
                            .init(color: .bw10.opacity(0.59), location: 0),
                            .init(color: .bw10.opacity(0), location: 0.48),
                            .init(color: .bw10, location: 1)
                        ],
                        startPoint: .bottom,
                        endPoint: .top)
                    VStack(alignment: .leading){
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
//                    BannerTopBar(true)
                    
                }
                VStack {
                    ActorData()
                    if let bio = viewModel.actor?.biography, bio != "" {
                        ActorBio(bio: bio)
                    }
                }
                .foregroundStyle(.white)
                .padding()
            }
            .scrollIndicators(.hidden)
//            BannerTopBar(true)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Movie")
                    }
                }
                .foregroundStyle(.blue1)
            }
        }
        .background(.bw10)
        .swipeToDismiss()
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            Task {
                await viewModel.getActor(id: id)
            }
        }
    }
    @ViewBuilder
    func ActorPhoto() -> some View {
        ZStack {
            Color.gray
                .aspectRatio(27/40, contentMode: .fill)
            AsyncImage(url: viewModel.actor?.profilePath) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .tint(.marsB)
                case .success(let image):
                    withAnimation(.easeIn) {
                        image
                            .resizable()
                            .aspectRatio(27/40, contentMode: .fill)
                    }
                case .failure(let error):
                    VStack {
                        Image(systemName: "photo")
                        Text(error.localizedDescription)
                    }
                @unknown default:
                    Color.gray
                }
            }
        }
        .clipped()
        .frame(maxWidth: .infinity)
    }
    @ViewBuilder
    func ActorData() -> some View {
        VStack {
            Text(viewModel.actor?.name ?? "No name")
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.title)
            HStack {
                Text("Actor")
                
                if let age = viewModel.actor?.age {
                    Text("|")
                    Text("\(age) years")
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.bw50)
        }
    }
    @ViewBuilder
    func ActorBio(bio: String) -> some View {
        VStack(alignment: .leading) {
            Text("Bio")
                .font(.hauora(size: 18, weight: .semibold))
            Text(bio)
                .lineLimit(viewMoreLimit)
            Button(action: {
                print("View more...")
                withAnimation(.snappy) {
                    if(viewMoreLimit != nil) {
                        viewMoreLimit = nil
                    } else {
                        viewMoreLimit = 5
                    }
                }
            }, label: {
                Text("View More ")
                    .foregroundStyle(.blue1)
                    .font(.hauora(size: 12))
                    .opacity(viewMoreLimit == nil ? 0 : 1)
            })
            .disabled(viewMoreLimit == nil)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    NavigationStack {
        ActorScreen(id: 10859)
    }
})
