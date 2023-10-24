//
//  Account.swift
//  Movix
//
//  Created by Ancel Dev account on 22/10/23.
//

import Foundation
import SwiftUI


struct Account: Codable, Identifiable {
    var id = UUID()
    var details: PersonalDetails
    var friends = [String]()
    var typeAccount: TypeAccount
    
    var profileImage: Image {
        Image("account_photo")
    }
    
    struct PersonalDetails: Codable {
        let name: String
        let email: String
        var birthdate = Date()
    }
    enum TypeAccount: Codable {
        case unsuscribed
        case normalSuscription
        case premiumSuscription
    }
    
}

extension Account {
    static var testAccount = Account(details: PersonalDetails(name: "Dama", email: "damaSan@gmail.com"), typeAccount: .normalSuscription)
}
