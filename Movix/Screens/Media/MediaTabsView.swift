//
//  MediaTabsView.swift
//  Movix
//
//  Created by Ancel Dev account on 1/3/25.
//

import SwiftUI

enum MediaTab: String, CaseIterable, Identifiable, Hashable {
    case general, details, reviews
    
    var id: Self { self }
}

struct MediaTabsView<TabContent: View>: View {
    
    @State private var selectedTab: MediaTab = .general
    
    let general: TabContent
    let details: TabContent
    let reviews: TabContent
    
    var body: some View {
        VStack {
            CustomSegmentedControl(state: $selectedTab)
            switch selectedTab {
            case .general:
                general
            case .details:
                details
            case .reviews:
                reviews
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: nil)
    }
}

//#Preview {
//    MediaTabsView()
//}
