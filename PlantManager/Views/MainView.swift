//
//  MainView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    @ObservedObject var roomVM = RoomViewModel()

    var body: some View {
        
        var plants = roomVM.currPlants
            ZStack {
                VStack {
                    //List(plants, rowContent: PlantCard.init)
                    List {
                        ForEach(plants, id: \.self) { plant in
                            NavigationLink(destination: DetailView(plant: plant)) {
                                PlantCard(plant: plant)
                            }
                            
                        }
                    }
                    
                    
                    Spacer()
                    NavigationLink(destination: PlantSearchView()) {
                        Text("New Plant")
                            .fontWeight(.semibold)
                            .font(.title)
                            
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.init(hex: "ECBEB4"))
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                    }
                }
            }.onAppear(perform: {
                roomVM.getData()
            })
    }
        
}
