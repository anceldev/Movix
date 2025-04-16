//
//  LanguageScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 26/2/25.
//

import SwiftUI

struct LanguageScreen: View {
    @Environment(UserViewModel.self) var userVM
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLan: String?
    @State private var showConfirmation: Bool = false
    
    @State private var searchTerm: String = ""
    @State private var debounceQuery = ""
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("account-language-title")
                        .font(.hauora(size: 20, weight: .medium))
                    Spacer()
                    Text(userVM.user.lang)
                        .font(.hauora(size: 20, weight: .black))
                }
                .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 8) {
                    Text("account-language-sub-title")
                        .font(.hauora(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 16) {
                        SearchField(searchTerm: $searchTerm, debounceQuery: $debounceQuery)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    ScrollView(.vertical) {
                        ForEach(searchTerm.isEmpty ? userVM.languages : userVM.languages.filter({ $0.englishName.contains(searchTerm) }), id: \.iso6391) { lang in
                            LanguageRow(lang)
                                .onTapGesture {
                                    withAnimation(.easeIn) {
                                        selectedLan = lang.iso6391
                                    }
                                }
                            Divider()
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .swipeToDismiss()
            }
            .padding([.horizontal, .bottom], 16)
        }
        .popView(isPresented: $showConfirmation, onDismiss: {
            showConfirmation.toggle()
        }, content: {
            CustomDialog(show: $showConfirmation, dialogType: .changeLanguage, onAccept: updateLanguage)
        })
        .background(.bw10)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    navigationManager.navigateBack()
                } label: {
                    BackButton(label: NSLocalizedString("account-tab-label", comment: "Account tab label"))
                }
            }
        }
        .onAppear {
            Task {
                await userVM.getLanguages()
            }
        }
    }
    private func updateLanguage() {
        Task {
            await userVM.updateUserLanguage(lang: selectedLan)
            navigationManager.navigateBack()
        }
    }

    @ViewBuilder
    func LanguageRow(_ lang: Language) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text(lang.englishName)
                .font(.hauora(size: 16))
                .foregroundStyle(selectedLan == lang.iso6391 ? .white : .bw50)
            Spacer(minLength: 0)
            if selectedLan == lang.iso6391 {
                Image(systemName: "checkmark")
                    .foregroundStyle(.white)
                    .fontWeight(.black)
                    .font(.system(size: 8))
                    .padding(6)
                    .background(.linearGradient(colors: [.marsA, .marsB], startPoint: .bottomLeading, endPoint: .topTrailing))
                    .clipShape(.circle)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LanguageScreen()
        .environment(UserViewModel(user: User.preview))
        .environment(NavigationManager())
}
