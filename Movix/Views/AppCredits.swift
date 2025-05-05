//
//  AppCredits.swift
//  Movix
//
//  Created by Ancel Dev account on 5/5/25.
//

import SwiftUI

struct AppCredits: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading) {
            Text("account-credits-label")
                .font(.hauora(size: 24, weight: .bold))
                            ScrollView(.vertical) {
                VStack(spacing: 32) {
                    VStack(alignment: .leading) {
                        Text("account-credits-attribution-tmdb-title")
                            .font(.hauora(size: 18, weight: .semibold))
                        VStack(alignment: .leading, spacing: 12) {
                            Text("account-credits-attribution-tmdb-text")
                                .font(.hauora(size: 16))
                            Link(destination: URL(string: "https://www.themoviedb.org")!) {
                                Image(.tmdbLogo)
                                    .padding(.leading)
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("account-credits-attribution-design-title")
                            .font(.hauora(size: 18, weight: .semibold))
                        VStack(alignment: .leading, spacing: 8) {
                            Text("account-credits-attribution-design-text")
                                .font(.hauora(size: 16))
                            Link(destination: URL(string: "https://www.behance.net/AnnaAkimenko")!) {
                                Text("account-credits-attribution-design-link")
                                    .foregroundStyle(.blue1)
                                    .opacity(0.8)
                                    .font(.hauora(size: 14))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
            .scrollIndicators(.hidden)
            Spacer()
        }
        .padding()
        .background(.bw10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button { 
                    dismiss()
                } label: {
                    BackButton(label: NSLocalizedString("account-tab-label", comment: "Account tab label"))
                }
            }
        }
        .swipeToDismiss()
    }
}

#Preview {
    AppCredits()
}
