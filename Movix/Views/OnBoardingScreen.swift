//
//  OnBoardingScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 15/5/25.
//

import SwiftUI

struct MovixFeature: Identifiable {
    var id = UUID()
    var title: String
    var headline: String
    var image: String
    var gradientColors: [Color]
}



struct OnBoardingView: View {
    let feature: MovixFeature
    @AppStorage("showOnboarding") var showOnboarding = true
    var body: some View {
        VStack {
            Text(feature.title)
            Text(feature.headline)
//            Image(feature.image)
            Image(systemName: feature.image)
            Button {
                showOnboarding = false
            } label: {
                Text("Skip")
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Gradient(colors: feature.gradientColors)
        )
    }
}

struct OnBoardingScreen: View {
    let onboardinView: [MovixFeature] = [
        .init(title: "First", headline: "View of the first onboardin", image: "person.fill", gradientColors: [.marsA, .marsB]),
        .init(title: "Second", headline: "Second view of onboarding", image: "house.fill", gradientColors: [.blue1, .blue2]),
        .init(title: "Third", headline: "Third feature", image: "house.fill", gradientColors: [.bw50, .bw90]),
        .init(title: "Final", headline: "Final view of onboarding", image: "star.fill", gradientColors: [.bw10, .bw20])
    ]
    var body: some View {
        TabView {
            ForEach(onboardinView) { view in
                OnBoardingView(feature: view)
            }
        }
        .ignoresSafeArea(.all)
        .tabViewStyle(.page)
    }
}

#Preview {
    OnBoardingScreen()
}
