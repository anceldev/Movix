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
    
    var body: some View {
        VStack {
            BannerTopBar(true)
            VStack(spacing: 16) {
                HStack {
                    Text("Current language")
                        .font(.hauora(size: 20, weight: .medium))
                    Spacer()
                    Text(userVM.language)
                        .font(.hauora(size: 20, weight: .black))
                }
                .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 8) {
                    Text("AVAILABLE LANGUAGES")
                        .font(.hauora(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
//                        .foregroundStyle(.bw50)
                    ScrollView(.vertical) {
                        ForEach(userVM.languages, id: \.iso6391) { lang in
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
                        updateLanguage()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .font(.hauora(size: 20, weight: .medium))
                    }
                    .buttonStyle(.capsuleButton)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding([.horizontal, .bottom], 16)
        }
        .background(.bw10)
        .onAppear {
            loadLanguages()
            selectedLan = userVM.language
        }
    }
    private func updateLanguage() {
        guard let lang = selectedLan else { return }
        userVM.language = lang
        dismiss()
    }
    private func loadLanguages() {
        Task {
            await userVM.getLanguages()
            userVM.languages.sort { $0.englishName < $1.englishName }
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
}
