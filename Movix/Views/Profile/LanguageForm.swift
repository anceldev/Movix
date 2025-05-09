//
//  LanguageForm.swift
//  Movix
//
//  Created by Ancel Dev account on 7/5/25.
//

import SwiftUI

struct LanguageForm: View {
    @Environment(\.dismiss) private var dismiss

    var apiLanguages: [Language]
    @Binding var selectedLan: String?
    var currentLang: String
    let action: () async -> Void
    
    @State private var showConfirmation: Bool = false
    @State private var searchTerm: String = ""
    @State private var debounceQuery = ""
    
    var languages: [Language] {
        Array(Set(searchTerm.isEmpty ? apiLanguages : apiLanguages.filter({ $0.englishName.contains(searchTerm) })).sorted(by: { $0.englishName < $1.englishName }))
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("account-language-title")
                        .font(.hauora(size: 20, weight: .medium))
                    Spacer()
                    Text(currentLang)
                        .font(.hauora(size: 20, weight: .black))
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 8) {
                    Text("account-language-sub-title")
                        .font(.hauora(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                    HStack(spacing: 16) {
                        SearchField(query: $searchTerm, debounceQuery: $debounceQuery)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(.horizontal)
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            ForEach(languages, id: \.iso6391) { lang in
                                LanguageRow(lang: lang, selected: $selectedLan)
                                    .onTapGesture {
                                        withAnimation(.easeIn) {
                                            selectedLan = lang.iso6391
                                        }
                                    }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    Button {
                        
                        showConfirmation.toggle()
                    } label: {
                        Text("save-button-label")
                            .frame(maxWidth: .infinity)
                            .font(.hauora(size: 20, weight: .medium))
                    }
                    .buttonStyle(.capsuleButton)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .swipeToDismiss()
            }
            .padding([.horizontal, .bottom], 16)
            Spacer()
        }
        .popView(isPresented: $showConfirmation, onDismiss: {
            showConfirmation.toggle()
        }, content: {
            CustomDialog(show: $showConfirmation, dialogType: .changeLanguage, onAccept: action)
        })
        .background(.bw10)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    dismiss()
                } label: {
                    BackButton(label: NSLocalizedString("account-tab-label", comment: "Account tab label"))
                }
            }
        }
    }
}
