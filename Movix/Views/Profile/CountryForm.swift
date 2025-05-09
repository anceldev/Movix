//
//  CountryForm.swift
//  Movix
//
//  Created by Ancel Dev account on 7/5/25.
//

import SwiftUI
import FlagsKit

struct CountryForm: View {
    @Environment(\.dismiss) private var dismiss

    var apiCountries: [Country]
    @Binding var selectedCountry: String?
    var currentCountry: String
    let action: () async -> Void
    
    @State private var showConfirmation: Bool = false
    @State private var query = ""
    @State private var debounceQuery = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                HStack {
                    Text("account-country-label")
                        .font(.hauora(size: 20, weight: .medium))
                    Spacer()
                    FlagView(countryCode: currentCountry)
                        .scaledToFit()
                        .frame(maxWidth: 24)
                        .clipShape(RoundedRectangle(cornerRadius: 2 ))
                    Text(currentCountry.uppercased())
                        .font(.hauora(size: 20, weight: .black))
                }
                .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 8) {
                    Text("account-country-sub-title")
                        .font(.hauora(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                    HStack(spacing: 16) {
                        SearchField(query: $query, debounceQuery: $debounceQuery)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    ScrollView(.vertical) {
                        ForEach(debounceQuery.isEmpty ? apiCountries : apiCountries.filter({ $0.englishName.contains(debounceQuery) }), id: \.iso31661) { country in
                            CountryRow(country, selectedCountry: $selectedCountry)
                                .onTapGesture {
                                    withAnimation(.easeIn) {
                                        selectedCountry = country.iso31661
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .swipeToDismiss()
            }
            .padding([.horizontal, .bottom], 16)
            
        }
        .popView(isPresented: $showConfirmation, onDismiss: {
            showConfirmation.toggle()
        }, content: {
            CustomDialog(show: $showConfirmation, dialogType: .changeCountry, onAccept: action)
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
