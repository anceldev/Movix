//
//  ListRow.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//

import SwiftUI

struct ListRow: View {
    let list: MediaList
    let media: SupabaseMedia
    let type: MediaType

    @Environment(UserViewModel.self) var userVM
    @State private var isAdddingToList = false
    
    var isIncluded: Bool {
        list.items.contains { $0.id == media.id }
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
            Button {
                isAdddingToList = true
                addMediaToList()
            } label: {
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
            .disabled(isAdddingToList)
        }
        .padding(.vertical, 8)
    }
    private func addMediaToList() {
        Task {
            if isIncluded {
                /// Call to add to list function
            } else {
                /// Call to delete from list function
                await userVM.addMediaToList(media: media, listId: list.id!, mediaType: type)
            }
            isAdddingToList = false
        }
    }
}
