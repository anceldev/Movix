//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import Foundation
import SwiftUI

struct Account: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var birthdate: Date
    var friends = [String]()
    var typeSuscription: TypeSubscription
    var isOnfile = false
    
    /*var profileImage: Image {
        Image("account_photo")
    }*/

    enum TypeSubscription: String, Codable {
        case noSpecified = "NoSpecified" // Used for create empty accounts if Firestore is note working
        case unsuscribed = "Unsuscribed"
        case normal = "Normal"
        case premium = "Premium"
    }
}

extension Account {
    static var testAccount = Account(id: "", name: "Dama", email: "damaSan@gmail.com", birthdate: Date(), typeSuscription: .normal)
}
