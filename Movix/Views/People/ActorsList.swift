//
//  ActorsList.swift
//  Movix
//
//  Created by Ancel Dev account on 7/3/25.
//

import SwiftUI

struct ActorsList: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showAllActorsButton: Bool
    var body: some View {
        VStack {
            Text("Actors list")
            Button {
                showAllActorsButton = false
                dismiss()
            } label: {
                Text("Go back")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
        .swipeToDismiss {
            showAllActorsButton = false
        }
    }
}

#Preview {
    ActorsList(showAllActorsButton: .constant(false))
}
