//
//  ListSelectorScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 6/5/25.
//

import SwiftUI

struct ListSelectorScreen: View {
    @Environment(UserViewModel.self) var userVM
    
    let media: SupabaseMedia
    let mediaType: MediaType
    
    var body: some View {
        VStack {
            Text("Añadir a lista")
                .font(.hauora(size: 20, weight: .semibold))
            ScrollView(.vertical) {
                VStack {
                    ForEach(userVM.user.lists.filter({ $0.listType == mediaType })) { list in
                        ListRow(list: list, media: media, type: mediaType)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
}

//
//#Preview(traits: .sizeThatFitsLayout) {
//    ListSelectorScreen(media: 1, mediaType: .movie)
//        .environment(UserViewModel(user: PreviewData.user))
//}
