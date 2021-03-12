//
//  FamilyFilter.swift
//  TrefleSwiftSDK
//
//  Created by James Barrow on 2020-10-05.
//  Copyright © 2020 Pig on a Hill Productions. All rights reserved.
//

import Foundation

public enum FamilyFilter: Hashable {
    case name
    case slug
    case other(String)
    
    public init(rawValue: String) {
        switch rawValue {
        case "name":
            self = .name
        case "slug":
            self = .slug
        default:
            self = .other(rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .name:
            return "name"
        case .slug:
            return "slug"
        case .other(let rawValue):
            return rawValue
        }
    }
    
}
