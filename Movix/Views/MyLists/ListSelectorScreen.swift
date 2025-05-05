//
//  ListSelectorScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//

import SwiftUI

struct ListSelectorScreen: View {
    @Environment(UserViewModel.self) var userVM
    let mediaId: Int
    let mediaType: MediaType
    var body: some View {
        VStack {
            Text("Añadir a lista")
                .font(.hauora(size: 20, weight: .semibold))
            ScrollView(.vertical) {
                VStack {
                    ForEach(userVM.user.lists.filter({ $0.listType == (mediaType == .movie ? .movie : .serie) })) { list in
                        ListRow(list: list, mediaId: mediaId)
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
}

struct ListRow: View {
    let list: MediaList
    let mediaId: Int
    
    var isIncluded: Bool {
        list.items.contains { $0.id == mediaId }
    }
    
    var body: some View {
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
            if isIncluded {
                Image(systemName: "checkmark")
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                    .font(.system(size: 8))
                    .padding(6)
                    .background(.linearGradient(colors: [.marsA, .marsB], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .clipShape(.circle)
            } else {
                Image(systemName: "circle")
            }
        }
        .padding(.vertical, 8)
        
    }
}

#Preview {
    ListSelectorScreen(mediaId: 1, mediaType: .movie)
        .environment(UserViewModel(user: PreviewData.user))
}
