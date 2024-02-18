//
//  Memes.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 06/02/24.
//

import Foundation

struct Memes: Decodable {
    let id : String
    let url : String
    let name : String
    let width : Int
    let height: Int
    let boxCount : Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case width
        case height
        case boxCount = "box_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.url = try container.decode(String.self, forKey: .url)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        self.height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        self.boxCount = try container.decodeIfPresent(Int.self, forKey: .boxCount) ?? 0
    }
    init(id: String, url: String, name: String, width: Int, height: Int, boxCount: Int) {
        self.id = id
        self.name = name
        self.url = url
        self.width = width
        self.height = height
        self.boxCount = boxCount
    }
}
