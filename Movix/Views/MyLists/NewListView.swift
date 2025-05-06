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
    @State private var newList: MediaList?
    @State private var name = ""
    @State private var description = ""
    @State private var listType: MediaType = .movie
    @State private var isPublic = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("New List View")
                .font(.hauora(size: 22, weight: .semibold))
            TextField("Name", text: $name)
            TextField("Description", text: $description)
            Picker("List type", selection: $listType) {
                ForEach(MediaType.allCases, id:\.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Is public", isOn: $isPublic)
            Button {
                createList()
            } label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.capsuleButton(name.isBlank ? .gray : .orangeGradient))
            .disabled(name.isBlank)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
    private func createList() {
        print("Create")
        Task {
            await userVM.createList(name: name, description: description, isPublic: isPublic, listType: listType)
            dismiss()
        }
    }
}

#Preview {
    NewListView()
        .environment(UserViewModel(user: PreviewData.user))
}
