//
//  MainView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct PlantView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
            ZStack {
                ToolbarView(title: self.selectedRoom.name ?? "Empty Room")
                    .padding(.top)
                Button("<") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(SmallBackButton())
                .offset(x: -90.0, y: 55.0)
            }
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
                destination: PlantSearchView(room: selectedRoom),
                isActive: $isPlantSearchShown) { EmptyView()}

        }.onAppear(perform: {
            plantViewModel.getData()
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct PlantPreview: PreviewProvider {
    static var previews: some View {
        PlantView(room: Room(rid: "", name: "Test", roomIconId: 0))
    }
}
#endif
