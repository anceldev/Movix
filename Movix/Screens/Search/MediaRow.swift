//
//  MediaRow.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct MediaRow<Content:View>: View {
    @Environment(MoviesViewModel.self) var moviesVM
    let title: String
    let backdropPath: String?
    let releaseDate: Date?
    let voteAverage: Double?
    let myRate: Int?
    @State private var image: Image? = nil
    @ViewBuilder let content: () -> Content
    
    init(title: String, backdropPath: String? = nil, releaseDate: Date? = nil, voteAverage: Double? = nil, myRate: Int? = nil, content: @escaping () -> Content) {
        
        self.title = title
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.myRate = myRate
        self.image = nil
        self.content = content
    }
    
    var body: some View {
        HStack {
            HStack {
                HStack {
                    ZStack {
                        Group {
                            if let image = image {
                                VStack {
                                    image
                                        .resizable()
                                        .aspectRatio(16/9, contentMode: .fill)
                                }
                            }
                            else {
                                ProgressView()
                                    .tint(.marsB)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        if let voteAverage = voteAverage {
                            if let formattedRate = NumberFormatter.popularity.string(from: NSNumber(value: voteAverage)) {
//                                VStack(alignment: .leading) {
//                                    ZStack(alignment: .center){
//                                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomTrailing: 10))
//                                            .fill(.black.opacity(0.8))
//                                        Text(formattedRate)
//                                            .foregroundStyle(.blue1)
//                                            .font(.hauora(size: 12))
//                                    }
//                                    .frame(width: 30, height: 20)
//                                }
//                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                Vote(value: formattedRate)
                            }
                        }
                        if let myRate = myRate {
                            Vote(value: String(myRate))
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.hauora(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.top, 8)
                    if let releaseDate = releaseDate {
                        Text(releaseDate.releaseDate())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                content()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 104)
        .onAppear {
            Task {
                self.image = await moviesVM.getBackdropImage(backdropPath: backdropPath)
            }
        }
    }
    @ViewBuilder
    func Vote(value: String) -> some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .center){
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomTrailing: 10))
                    .fill(.black.opacity(0.8))
                Text(value)
                    .foregroundStyle(.blue1)
                    .font(.hauora(size: 12))
            }
            .frame(width: 30, height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
