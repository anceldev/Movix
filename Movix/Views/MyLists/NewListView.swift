//
//  NewListView.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI

struct NewListView: View {
    @Environment(UserViewModel.self) var userVM
    @Environment(\.dismiss) private var dismiss
    
    let listType: ListControlsMedia

    @State private var newList: MediaList?
    @State private var name = ""
    @State private var description = ""
    @State private var isPublic = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("media-list-title")
                .font(.hauora(size: 20, weight: .semibold))
            TextField(NSLocalizedString("media-list-name-placeholder", comment: "name"), text: $name)
                .customCapsule(.bw50, input: true, bg: .bw40)
            
            TextField(NSLocalizedString("media-list-description-placeholder", comment: "description"), text: $description)
                .customCapsule(.bw50, input: true, bg: .bw40)
            Spacer()
            Button {
                createList()
            } label: {
                Text("media-list-btn-label")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.capsuleButton(name.isBlank ? .gray : .orangeGradient))
            .disabled(name.isBlank)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bwg)
        .enableInjection()
    }
    private func createList() {
        Task {
            await userVM.createList(name: name, description: description, isPublic: isPublic, listType: listType)
            dismiss()
        }
    }
}
