//
//  MovieTabsView.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

enum MovieTab: String, CaseIterable {
    case general, details, reviews
}
struct MovieTabsView: View {
    /// View Properties
    @State private var selectedTab: MovieTab? = .general
    @Environment(\.colorScheme) private var scheme
    @Environment(MovieViewModel.self) var movieVM
    /// Tab Progress
    @State private var tabProgress: CGFloat = 0
        @State private var viewHeight: CGFloat = 300 // Add this line

    var body: some View {
        VStack(spacing: 15) {
            /// Custom Tab Bar
            CustomTabBar()
            switch selectedTab {
            case .general:
//                GeneralTabView(cast: movieVM.cast)
                GeneralTabView(id: movieVM.movie?.id ?? 0)
                    .environment(movieVM)
            case .details:
                DetailsTabView(movie: movieVM.movie!)
            case .reviews:
                ReviewsTabView()
                    .environment(movieVM)
            case nil:
                EmptyView()
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
