//
//  Room.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/30/21.
//

import Foundation

struct Room: Hashable, Decodable, Encodable {
    var rid: String?
    var name: String?
    var roomIconId: Int?
    
    init(rid: String?, name: String?, roomIconId: Int?){
        self.rid = rid
        self.name = name
        self.roomIconId = roomIconId
    }
    
}

struct RoomPost: Encodable {
    let name: String
    let roomIconId: Int
}
