//
//  ProfileForm.swift
//  Movix
//
//  Created by Ancel Dev account on 7/5/25.
//

import SwiftUI
import FlagsKit

struct ProfileForm: View {
    private enum FocusedField {
        case username
    }
    
    @Environment(Auth.self) var authVM
    
    @FocusState private var focusedField: FocusedField?
    
    @State private var showLanguageSelector = false
    @State private var showCountrySelector = false
    @State private var showAvatarPicker = false
//    @State private var avatarImage: UIImage?
    @Binding var avatar: UIImage?
    
    @State private var selectedLang: String? = "en"
    @State private var selectedCountry: String? = "US"
    @State private var username: String = ""
    let action: (UIImage?, String, String?, String?) async -> Void
    
    var body: some View {
//        @Bindable var authVM = authVM
        VStack(spacing: 28) {
            VStack(spacing: 16) {
                TextField("Username", text: $username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .customCapsule(focusedField == .username || username != "" ? .white : .bw50, input: true)
                    .foregroundStyle(username != "" ? .white : .bw50)
                    .focused($focusedField, equals: .username).animation(.easeInOut, value: focusedField)
                    .onSubmit {
                        focusedField = nil
                    }
                    .submitLabel(.next)
                HStack(spacing: 16) {
                    Button {
                        showLanguageSelector.toggle()
                    } label: {
                        Text(selectedLang ?? "en")
                            .font(.hauora(size: 22, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.trailing)
                    }
                    .customCapsule(.white, input: true)
                    Button {
                        showCountrySelector.toggle()
                    } label: {
                        HStack {
                            FlagView(countryCode: selectedCountry ?? "US")
                                .scaledToFit()
                                .frame(maxWidth: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 2 ))
                            Text(selectedCountry ?? "US")
                                .font(.hauora(size: 22, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.trailing)
                    }
                    .customCapsule(.white, input: true)
                }
                .frame(maxWidth: .infinity)
                Button {
                    Task {
                        await action(avatar, username, selectedLang, selectedCountry)
                    }
                } label: {
                    Text("signup-profile-button")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.capsuleButton(.orangeGradient))
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 27)
        .sheet(isPresented: $showLanguageSelector) {
            VStack {
                LanguageForm(
                    apiLanguages: TMDBService.shared.languages,
                    selectedLan: $selectedLang,
                    currentLang: authVM.user?.lang ?? "en",
                    action: { showLanguageSelector = false }
                )
            }
            .padding(.vertical, 32)
            .background(.bw10)
            .environment(authVM)
        }
        .sheet(isPresented: $showCountrySelector) {
            VStack {
                CountryForm(
                    apiCountries: TMDBService.shared.countries,
                    selectedCountry: $selectedCountry,
                    currentCountry: authVM.user?.country ?? "US",
                    action: { showCountrySelector = false }
                )
            }
            .padding(.vertical, 32)
            .background(.bw10)
            .environment(authVM)
        }
        .onAppear {
            Task {
                do {
                    _ = try await TMDBService.shared.getLanguages(lang: "en")
                    _ = try await TMDBService.shared.getCountries(lang: selectedLang ?? "en", country: "US")
                } catch {
                    authVM.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ProfileForm(avatar: .constant(nil), action: {_,_,_,_ in })
        .environment(Auth())
        .background(.bw10)
}

