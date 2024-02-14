//
//  TestView.swift
//  Movix
//
//  Created by Ancel Dev account on 14/2/24.
//

import SwiftUI

struct TestView: View {
    let id: Int
    var body: some View {
        Text("Id is: \(id)")
    }
}

#Preview {
    TestView(id: 0)
}
