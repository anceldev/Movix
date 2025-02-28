//
//  Response.swift
//  Movix
//
//  Created by Ancel Dev account on 18/2/25.
//

import Foundation

struct Response: Codable {
    let success: Bool?
    let expiresAt: Date?
    let token: String?
    let sessionId: String?
    let listId: Int?
    
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case sessionId = "session_id"
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case listId = "list_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.success = try values.decode(Bool.self, forKey: .success)
        if let expiresDate = try values.decodeIfPresent(String.self, forKey: .expiresAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.expiresAt = dateFormatter.date(from: expiresDate)
        } else {
            self.expiresAt = nil
        }
        self.token = try values.decodeIfPresent(String.self, forKey: .requestToken)
        self.sessionId = try values.decodeIfPresent(String.self, forKey: .sessionId)
        self.statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        self.statusMessage = try values.decodeIfPresent(String.self, forKey: .statusMessage)
        self.listId = try values.decodeIfPresent(Int.self, forKey: .listId)
    }
    func encode(to encoder: any Encoder) throws {
        
    }
}
