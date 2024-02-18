//
//  Data.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 06/02/24.
//

import Foundation

struct DataResponse: Decodable{
    let pictures: [Memes]
    
    enum CodingKeys: String, CodingKey {
        case pictures
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pictures = try container.decodeIfPresent([Memes].self, forKey: .pictures) ?? []
    }
}
