//
//  CountryRow.swift
//  Movix
//
//  Created by Ancel Dev account on 16/4/25.
//

import SwiftUI
import FlagsKit

struct CountryRow: View {
    let country: Country
    @Binding var selectedCountry: String?
    
    init(_ country: Country, selectedCountry: Binding<String?>) {
        self.country = country
        self._selectedCountry = selectedCountry
    }
    
    var body: some View {
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
