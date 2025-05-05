//
//  NewListView.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI

struct NewListView: View {
    var body: some View {
        VStack {
            Text("New List View")
                .font(.hauora(size: 22, weight: .semibold))
            Spacer()
            Button {
                print("Create")
            } label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.capsuleButton)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.filtersBackground)
    }
}

#Preview {
    NewListView()
}
