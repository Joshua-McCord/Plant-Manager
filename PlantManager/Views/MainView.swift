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
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        
        let plants = roomVM.currPlants
            ZStack {
                VStack {
                    Text("Bedroom")
                        .font(Font.custom("Futura-Medium", size: 64.0))
                        .foregroundColor(.black)
                    ScrollView {
                        LazyVGrid(columns: gridItemLayout, spacing: 20) {
                            ForEach(plants, id: \.self) { plant in
                                NavigationLink(destination: DetailView(plant: plant)) {
                                    PlantCard(plant: plant)
                                }
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

#if DEBUG
struct MainPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
