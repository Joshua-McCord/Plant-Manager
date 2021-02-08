//
//  Plant.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation

struct Plant: Hashable, Decodable, Encodable {
    var uid: String?
    var name: String?
    var waterAt: String?
    var treflePlantId: String?
    init(uid: String?, name: String?, waterAt: String?, treflePlantId: String?){
        self.uid = uid
        self.name = name
        self.waterAt = waterAt
        self.treflePlantId = treflePlantId
    }
    
}


struct PlantPost: Encodable, Decodable {
    let name: String?
    let waterAt: String?
    let treflePlantId: String?
}

/*
extension PlantGet {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case data = "data"
    }
}
extension Plant {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case treflePlantId = "treflePlantId"
        case
    }
}
 */


