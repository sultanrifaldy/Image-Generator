//
//  Data.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 07/02/24.
//

import Foundation

struct Data: Decodable {
    let success: Bool
    let data: DataClass
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
        self.data = try container.decode(DataClass.self, forKey: .data)
    }
}
