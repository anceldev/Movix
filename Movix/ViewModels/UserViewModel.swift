//
//  UserViewModel.swift
//  Movix
//
//  Created by Ancel Dev account on 8/2/25.
//

import Foundation

@Observable
final class UserViewModel {
    var user: Account
    
    init(user: Account) {
        self.user = user
    }
}


extension Account {
    static var preview = Account(
        id: UUID(),
        username: "Dani",
        email: "dani@mail.com"
    )
}
