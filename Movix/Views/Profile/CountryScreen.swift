//
//  CountryScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 13/3/25.
//

import SwiftUI
import FlagsKit

struct CountryScreen: View {
    @Environment(UserViewModel.self) var userVM
    @Environment(\.dismiss) private var dismiss
    @Environment(NavigationManager.self) var navigationManager
    @State private var selectedCountry: String?
    @State private var showConfirmation: Bool = false
    @State private var searchTerm = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("account-country-label")
                        .font(.hauora(size: 20, weight: .medium))
                    Spacer()
                    FlagView(countryCode: userVM.country)
                        .scaledToFit()
                        .frame(maxWidth: 24)
                        .clipShape(RoundedRectangle(cornerRadius: 2 ))
                    Text(userVM.country.uppercased())
                        .font(.hauora(size: 20, weight: .black))
                }
                .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 8) {
                    Text("account-country-sub-title")
                        .font(.hauora(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 16) {
                        SearchField(searchTerm: $searchTerm, loadAction: {}, clearAction: {})
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    ScrollView(.vertical) {
                        ForEach(searchTerm.isEmpty ? userVM.countries : userVM.countries.filter({ $0.englishName.contains(searchTerm) }), id: \.iso31661) { country in
                            CountryRow(country)
                                .onTapGesture {
                                    withAnimation(.easeIn) {
                                        selectedCountry = country.iso31661
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
            CustomDialog(show: $showConfirmation, dialogType: .changeCountry, onAccept: updateCountry)
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
            loadCountries()
            selectedCountry = userVM.country
        }
    }
    private func updateCountry() {
        guard let country = selectedCountry else { return }
        userVM.country = country
        navigationManager.navigateBack()
    }
    private func loadCountries() {
        Task {
            await userVM.getCountries()
            userVM.countries.sort { $0.nativeName < $1.nativeName }
        }
    }
    func CountryRow(_ country: Country) -> some View {
        HStack(alignment: .center, spacing: 8) {
            FlagView(countryCode: country.iso31661)
                .scaledToFit()
                .frame(maxWidth: 24)
                .opacity(selectedCountry == country.iso31661 ? 1 : 0.4)
                .clipShape(RoundedRectangle(cornerRadius: 2 ))
            Text(country.nativeName)
                .font(.hauora(size: 16))
                .foregroundStyle(selectedCountry == country.iso31661 ? .white : .bw50)
            Spacer(minLength: 0)
            if selectedCountry == country.iso31661 {
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
    CountryScreen()
        .environment(UserViewModel(user: User.preview))
        .environment(NavigationManager())
}
