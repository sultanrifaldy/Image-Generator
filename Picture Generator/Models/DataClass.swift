//
//  DataClass.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 07/02/24.
//

import Foundation

struct DataClass: Decodable {
    let memes: [Memes]
    
    enum CodingKeys: String, CodingKey {
        case memes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.memes = try container.decode([Memes].self, forKey: .memes)
    }
}
