//
//  Date+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

extension Date {
    func releaseDate() -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        
        if calendar.isDate(self, equalTo: .now, toGranularity: .year) {
            formatter.dateFormat = "d MMM"
        } else {
            formatter.dateFormat = "MMM yyyy"
        }
        return formatter.string(from: self)
    }
}
