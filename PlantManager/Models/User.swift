//
//  User.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/6/21.
//

import Foundation

class User : Decodable {
    // Singleton Architecture 
    static var sharedInstance: User = {
        let instance = User()
        // setup code
        return instance
    }()
    
    
    var displayName = String()
    var email = String()
    var idToken = String()
    var kind = String()
    var localId = String()
    var registered = Bool()
     
}
