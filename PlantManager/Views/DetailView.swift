//
//  DetailView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct DetailView: View {
    var plant: Plant
    
    var body: some View {
        Text(plant.name!)
    }
}

