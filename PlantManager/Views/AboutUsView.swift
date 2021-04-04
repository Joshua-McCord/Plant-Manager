//
//  AboutUsView.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/4/21.
//

import Foundation
import SwiftUI

struct AboutUsView: View {
    
    @State private var isBedroomShowing = false
    
    var body: some View {
        VStack {
            ToolbarView(title: "Seedling")
                .padding(.top)
            
            Text("Seedling allows you to keep your house plants happy and healthy.\n\nYou can create virtual rooms to organize your plants, and each virtual plant contains resources and recommendations to alleviate the stress of being a plant parent.\n\nOur mission is to guide all plant lovers; time to watch those seedlings grow!")
                .font(Font.custom("SFProText-Regular", size: 18.0))
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            
            Button("Get Started!") {
                self.isBedroomShowing = true
            }
                .buttonStyle(LongGreenButton())
            
            NavigationLink(
                destination: MainView(),
                isActive: $isBedroomShowing) { EmptyView()}
            
            GeometryReader { geometry in
                Image("background")
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .clipped()
            }.ignoresSafeArea()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct AboutUsPreview: PreviewProvider {
    static var previews: some View {
        AboutUsView()
    }
}
#endif
