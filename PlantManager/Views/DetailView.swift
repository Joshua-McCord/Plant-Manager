//
//  DetailView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct DetailView: View {
    
    @ObservedObject var detailViewModel: DetailViewModel
    
    
    init(plant: Plant) {
        self.detailViewModel = DetailViewModel(plant: plant)
    }
    
    
    var body: some View {
        
        VStack {
            Image("golden-pothos")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.screenWidth, height: 450, alignment: .top)
                .clipShape(Rectangle())
                .cornerRadius(14).offset(x: 0, y: 60)
                
            ZStack {
                Rectangle()
                    .fill(Color("Primary"))
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight/1.5, alignment: .bottom)
                    .cornerRadius(64)
                    .shadow(color: .black, radius: 10, x: 0.0, y: 10)
                    
                Text(detailViewModel.getPlantName())
                    .font(Font.custom("Futura-Medium", size: 64.0))
                    .foregroundColor(.black)
                    .offset(x: 0, y: -200)
                
                if(detailViewModel.getHasConnectedDevice()) {
                    Text("Moisture Level: \(detailViewModel.getPlantMoistureLevel())%")
                        .font(Font.custom("SFProText-Regular", size: 18))
                        .foregroundColor(.black)
                        .offset(x: 0, y: 50)
                }
                
            }.offset(x: 0, y: -10)
        }.modifier(CardModifier())
        .onAppear(perform: {
            detailViewModel.getPlantInformation()
        })
        
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(plant: Plant(uid: "uid", name: "name", waterAt: "10", treflePlantId: "123", hasConnectedDevice: "false"))
    }
}
#endif
