//
//  MediaItemsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct ContentView2: View {
    @State private var showIcon = false
    
    var body: some View {
        NavigationStack {
            List {
                Text("Currently Testing")
                    .font(.headline)
                    .fontWeight(.bold)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                
                NavigationLink(destination: detail) {
                    row
                }
            }
            .listRowSpacing(5)
            .navigationTitle("Apps")
        }.tint(.white)
    }
    
    var row: some View {
        HStack {
            AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/2048px-Apple_Music_icon.svg.png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(width: 50, height: 50)
            VStack(alignment:.leading) {
                Text("Apple Music")
                Text("Version 10.0.0 (10A532)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Expires in 90 days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }.padding(.horizontal)
        }
    }

    var detail: some View {
        ScrollView {
            VStack {
                detailHeader
                
                VStack(spacing: 20) {
                    detailInfo
                    
                    detailTest
                    
                    screenshots
                }.padding()
                
                Spacer()
            }
            .background(GeometryReader { proxy in
                Color.clear
                    .onChange(of: proxy.frame(in: .global).minY) { newValue in
                        withAnimation {
                            if newValue < 0 {
                                showIcon = true
                            } else {
                                showIcon = false
                            }
                        }
                    }
            })
        }
        .ignoresSafeArea(.all)
        .toolbar {
            ToolbarItem(placement: .principal) {
                AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/2048px-Apple_Music_icon.svg.png")) { image in
                image.resizable()
                } placeholder: {
                    ProgressView()
                }.frame(width: 25, height: 25)
                .opacity(showIcon ? 1 : 0)
                .animation(.easeInOut(duration: 0.5))
            }
        }
    }
    
    var detailHeader: some View {
        VStack {
            AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/2048px-Apple_Music_icon.svg.png")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 125, height: 125)
            .padding(.top,75)
            
            Text("Apple Music")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
            
            HStack {
                Button(action:{}) {
                    Spacer()
                    Text("Open")
                        .padding(.vertical,5)
                    Spacer()
                }.buttonStyle(.bordered)
                .tint(.white)
                
                Button(action:{}) {
                    Spacer()
                    Text("Send Feedback")
                        .padding(.vertical,5)
                    Spacer()
                }.buttonStyle(.bordered)
                .tint(.white)
            }
        }
        .padding()
        .background {
            LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.red.opacity(0.3)]),
                               startPoint: .top,
                               endPoint: .bottom)
        }.frame(maxHeight: 350)
    }
    
    var detailInfo: some View {
        HStack {
            HStack {
                Spacer()
                VStack(spacing:5) {
                    Text("DEVELOPER")
                        .fontWeight(.medium)
                    Image(systemName: "applelogo")
                        .font(.headline)
                    Text("Apple Inc.")
                }.font(.caption)
                Spacer()
            }.foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                Spacer()
                VStack(spacing:5) {
                    Text("CATEGORY")
                        .fontWeight(.medium)
                    Image(systemName: "music.quarternote.3")
                        .font(.headline)
                    Text("Music")
                }.font(.caption)
                Spacer()
            }.foregroundStyle(.secondary)
            
            Divider()
            
            HStack {
                Spacer()
                VStack(spacing:5) {
                    Text("EXPIRES")
                        .fontWeight(.medium)
                    Text("90")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Days")
                }.font(.caption)
                Spacer()
            }.foregroundStyle(.secondary)
        }.padding(.vertical)
        .background(Color.secondary.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxHeight: 80)
    }
    
    var detailTest: some View {
        VStack {
            HStack {
                Text("What to Test")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }.opacity(0.9)
            
            Text("Get unlimited access to 100 million songs. Hear sound all around you with Spatial Audio featuring Dolby Atmos.")
                .foregroundStyle(.white.opacity(0.8))
                .padding()
                .background(Color.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    var screenshots: some View {
        VStack {
            HStack {
                Text("Screenshots")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }.opacity(0.9)
            
            ScrollView(.horizontal) {
                HStack {
                    AsyncImage(url: URL(string: "https://www.apple.com/newsroom/images/live-action/wwdc-2023/standard/services-roundup/Apple-WWDC23-iOS-17-Apple-Music-SharePlay-subscribe_inline.jpg.large_2x.jpg")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    AsyncImage(url: URL(string: "https://www.apple.com/newsroom/images/live-action/wwdc-2023/standard/services-roundup/Apple-WWDC23-iOS-17-Apple-Music-SharePlay-home_inline.jpg.large_2x.jpg")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    AsyncImage(url: URL(string: "https://www.apple.com/newsroom/images/live-action/wwdc-2023/standard/services-roundup/Apple-WWDC23-iOS-17-Apple-Music-SharePlay-playlist_inline.jpg.large_2x.jpg")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }.frame(height:350)
        }
    }
}

#Preview {
    ContentView2()
}
