//
//  TitleView.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/21/21.
//

import Foundation
import SwiftUI

struct TitleView: View {
    
    @State private var timeDone = false
    
    var body: some View {
        VStack {
            ZStack {
                Image("logo")
                    .clipShape(Circle())
                    .scaleEffect(CGSize(width: 0.15, height: 0.15))
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                            withAnimation(.easeInOut(duration: 2)) {
                                self.timeDone = true
                            }
                        }
                    }
            }
        
            NavigationLink(destination: AccountView(), isActive: $timeDone) { EmptyView() }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#if DEBUG
struct TitlePreview: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
#endif
