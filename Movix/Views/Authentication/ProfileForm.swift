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
    
    @Environment(AuthViewModel.self) var authVM
//    @Environment(NavigationManager.self) var navigationManager
    
    @FocusState private var focusedField: FocusedField?
    
    @State private var showLanguageSelector = false
    @State private var showCountrySelector = false
    @State private var showAvatarPicker = false
    @State private var avatarImage: UIImage?
    
    
    @State private var selectedLang: String? = "en"
    @State private var selectedCountry: String? = "US"
    
    var body: some View {
        @Bindable var authVM = authVM
        VStack(spacing: 28) {
            VStack {
                VStack(spacing: 36) {
                    Text(NSLocalizedString("signup-profile-title", comment: "Perfil"))
                        .font(.hauora(size: 34))
                    VStack {
                        if let avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(.circle)
                                .overlay {
                                    Circle().stroke(LinearGradient(colors: [.marsA, .marsB], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                                }
                        } else {
                            VStack(spacing: 12) {
                                Image("profileDefault")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 80)
                            }
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            showAvatarPicker.toggle()
                        } label: {
                            Image(systemName: "photo")
                                .font(.system(size: 10))
                                .padding(6)
                                .background(.bw10)
                                .clipShape(.circle)
                                .foregroundStyle(.white)
                                .overlay {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1)
                                }
                        }

                    }
                }
                .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 16) {
                TextField("Username", text: $authVM.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .customCapsule(focusedField == .username || authVM.username != "" ? .white : .bw50, input: true)
                    .foregroundStyle(authVM.username != "" ? .white : .bw50)
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
                    print("Sign up...")
                    updateProfile()
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
//            .environment(navigationManager)
            
        }
        .cropImagePicker(show: $showAvatarPicker, croppedImage: $avatarImage)
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
//            .environment(navigationManager)
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
    
    private func updateProfile() {
        Task {
            await authVM.setUserPreferences(avatarImage: avatarImage, lang: selectedLang, country: selectedCountry)
        }
    }
}

#Preview {
    ProfileForm()
        .environment(AuthViewModel())
//        .environment(NavigationManager())
        .background(.bw10)
}

