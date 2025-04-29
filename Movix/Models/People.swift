//
//  People.swift
//  Movix
//
//  Created by Ancel Dev account on 7/2/25.
//

import Foundation

struct People: Identifiable, Codable {
    let id: Int
    let name: String
    let biography: String?
    let birthday: Date?
    let gender: Gender?
    let homepage: URL?
    let popularity: Double?
    let profilePath: URL?

    
    var age: Int? {
        let calendar = Calendar.current
        if self.birthday != nil {
            let yearComponent = calendar.dateComponents([.year], from: self.birthday!, to: .now)
            return yearComponent.year
        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case birthday
        case gender
        case homepage
        case popularity
        case profilePath = "profile_path"
    }
    
    enum Gender: String {
        case ns = "No specified"
        case female = "Female"
        case male = "Male"
        case nb = "Non binary"
    }
    
    init(id: Int, name: String, biography: String?, birthday: Date?, gender: Gender?, homepage: URL?, popularity: Double?, profilePath: URL?) {
        self.id = id
        self.name = name
        self.biography = biography
        self.birthday = birthday
        self.gender = gender
        self.homepage = homepage
        self.popularity = popularity
        self.profilePath = profilePath
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        
        self.biography = try values.decodeIfPresent(String.self, forKey: .biography)
        
        if let birthOn = try values.decodeIfPresent(String.self, forKey: .birthday) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birthday = dateFormatter.date(from: birthOn)
        } else {
            self.birthday = nil
        }
        
        if let genderP = try values.decodeIfPresent(Int.self, forKey: .gender) {
            switch genderP {
            case 2: self.gender = .female
            case 3: self.gender = .male
            case 4: self.gender = .nb
            default:
                self.gender = .ns
            }
        } else {
            self.gender = .ns
        }
        self.homepage = try values.decodeIfPresent(URL.self, forKey: .homepage)
        self.popularity = try values.decodeIfPresent(Double.self, forKey: .popularity)
        let profile = try values.decodeIfPresent(String.self, forKey: .profilePath)
        self.profilePath = URL(string: "https://image.tmdb.org/t/p/w780\(profile ?? "")")
    }
    func encode(to encoder: any Encoder) throws {
    }
} 
