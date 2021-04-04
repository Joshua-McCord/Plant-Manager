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
    @State private var isPlantSearchShown = false
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        
        let plants = roomVM.currPlants
        VStack {
            ToolbarView(title: "Bedroom")
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
            roomVM.getData()
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}


#if DEBUG
struct MainPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
