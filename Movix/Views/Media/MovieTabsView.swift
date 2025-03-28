//
//  MovieTabsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

enum MovieTab: String, CaseIterable, Identifiable, Hashable, Localizable {
    case general, details, reviews
    
    var id: Self { self }
    
    var localizedTitle: String {
        switch self {
        case .general:
            return NSLocalizedString("movie-tabs-general", comment: "General")
        case .details:
            return NSLocalizedString("movie-tabs-details", comment: "Details")
        case .reviews:
            return NSLocalizedString("movie-tabs-reviews", comment: "Reviews")
        }
    }
}
struct MovieTabsView<Content:View>: View {
    /// View Properties
    @State private var selectedTab: MovieTab = .general
    @Environment(\.colorScheme) private var scheme
    @Environment(MovieViewModel.self) var movieVM
    @Environment(UserViewModel.self) var userVM
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
    @State private var viewHeight: CGFloat = 300 // Add this line
    
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 15) {
            /// Custom Tab Bar
//            CustomTabBar()
            CustomSegmentedControl(state: $selectedTab)
            switch selectedTab {
            case .general:

                content
            case .details:
//                DetailsTabView(movie: movieVM.movie!)
//                Text("Details tab View")
//                DetailsTabView<Movie>(media: movieVM.movie!)
                Text("Details tab view")
            case .reviews:
                Text("Reviews tab View")
//                ReviewsList()
//                    .environment(movieVM)
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
       .frame(height: nil)
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(MovieTab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Text(tab.rawValue.capitalized)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    /// Updating Tab
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
                .overlay {
                    Rectangle()
                        .fill(selectedTab == tab ? .blue1 : .clear)
                        .frame(height: 4)
                        .offset(y: 18)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}
