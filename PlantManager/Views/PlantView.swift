//
//  MainView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct PlantView: View {
    @State private var isPlantSearchShown = false
    @ObservedObject var plantViewModel = PlantViewModel()
    private var selectedRoom: Room
    
    init(room: Room) {
        self.selectedRoom = room
    }
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        
        let plants = plantViewModel.getPlantsInRoom(room: self.selectedRoom)
        VStack {
            ToolbarView(title: self.selectedRoom.name ?? "Empty Room")
                .padding(.top)
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(plants, id: \.self) { plant in
                        NavigationLink(destination: DetailView(plant: plant)) {
                            PlantCard(plant: plant)
                        }
                    }
                }
            }.padding(.horizontal)
            
            Spacer()
            Button("New Plant") {
                self.isPlantSearchShown = true
            }
                .buttonStyle(LongGreenButton())
            
            NavigationLink(
                destination: PlantSearchView(),
                isActive: $isPlantSearchShown) { EmptyView()}

        }.onAppear(perform: {
            plantViewModel.getData()
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
