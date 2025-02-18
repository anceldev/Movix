//
//  ActorScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ActorScreen: View {
    @State private var viewModel = PeopleViewModel()
    @State private var viewMoreLimit: Int? = 5
    let id: Int

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                ZStack {
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
            BannerTopBar(true)
                .padding(.top, 44)
        }
        .background(.bw10)
        .ignoresSafeArea()
        .swipeToDismiss()
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
//                .fontWeight(.semibold)
//                .font(.system(size: 18))
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
                Text(viewMoreLimit == nil ? "View less" : "View More ")
                    .foregroundStyle(.blue1)
            })
        }
    }
}

#Preview(traits: .sizeThatFitsLayout, body: {
    ActorScreen(id: 10859)
})
