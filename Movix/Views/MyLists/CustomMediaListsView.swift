//
//  CustomMediaListsView.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//

import SwiftUI

struct CustomMediaListsView: View {
    let list: [MediaList]
    @Environment(NavigationManager.self) var navigationManager
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(list) { list in
                    Button {
                        navigationManager.navigate(to: .list(list: list))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(list.name)
                                    .font(.hauora(size: 16))
                                    .foregroundStyle(.white)
                                if let description = list.description {
                                    Text(description)
                                        .font(.hauora(size: 12))
                                        .foregroundStyle(.bw50)
                                }
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.bw50)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}
