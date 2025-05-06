//
//  ListScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//

import SwiftUI

struct ListScreen: View {
    let list: MediaList
    
    init(_ list: MediaList) {
        self.list = list
    }
    var body: some View {
        VStack {
            Text(list.name)
                .font(.hauora(size: 22, weight: .semibold))
            if let description = list.description {
                Text(description)
                    .font(.hauora(size: 12))
                    .foregroundStyle(.bw50)
            }
            ScrollView(.vertical) {
                GridItemsView2(
                    mediaItems: list.items,
                    mediaType: list.listType == .movie ? .movie : .serie,
                    columns: 3
                )
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.bw10)
    }
}

#Preview {
    ListScreen(PreviewData.movieLists[0])
}
