//
//  DataClass.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 07/02/24.
//

import Foundation

struct DataClass: Decodable {
    let success: Bool
    let data: Data
    
    enum CodingKeys: String, CodingKey {
        case success
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.data = try container.decode(Data.self, forKey: .data)
    }
}
