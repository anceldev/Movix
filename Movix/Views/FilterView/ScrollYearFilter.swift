//
//  ScrollYearFilter.swift
//  Movix
//
//  Created by Ancel Dev account on 15/5/25.
//

import SwiftUI

struct ScrollYearFilter: View {
    @Binding var selectedYear: Int?
    let currentYear: Int
    let startYear = 1900
    let years: [Int]
    
    init(selectedYear: Binding<Int?>) {
        self._selectedYear = selectedYear
        self.currentYear = Calendar.current.component(.year, from: Date())
        let years = Array(startYear...currentYear)
        self.years = years.reversed()
    }
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(years, id: \.self) { year in
                        Button {
                            // Tu acción aquí
                            withAnimation(.easeIn) {
                                if selectedYear == year {
                                    selectedYear = nil
                                } else {
                                    selectedYear = year
                                }
                            }
                        } label: {
                            Text(year == currentYear 
                            ? "\(year, format: .number.grouping(.never))" 
                            : "\(year, format: .number.grouping(.never))")
                                .font(.hauora(size: 18, weight: selectedYear == year ? .bold : .medium))
                                .foregroundStyle(selectedYear == year ? .bw20 : .white)
                        }
                        .padding(4)
                        .padding(.horizontal, 8)
                        .background(selectedYear == year ? .blue1 : .bw20)
                        .clipShape(.capsule)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var selectedYear: Int? = nil
    ScrollYearFilter(selectedYear: $selectedYear)
}
