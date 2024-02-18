//
//  Memes.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 07/02/24.
//

import Foundation

struct Memes: Decodable {
    let name : String
    let id: String
    let url: String
    let width: Int
    let height: Int
    let boxCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case url
        case width
        case height
        case boxCount = "box_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        self.height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        self.boxCount = try container.decodeIfPresent(Int.self, forKey: .boxCount) ?? 0
    }
    
}
