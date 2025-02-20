//
//  HomeScreen.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(MoviesViewModel.self) var moviesVM
    var body: some View {
        VStack {
            Text("Welcome to Movix")
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bw10)
    }
}

#Preview {
    HomeScreen()
        .environment(MoviesViewModel())
}
