//
//  ChooseRoomView.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/30/21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var roomVM = RoomViewModel()
    @State private var showNewRoom = false
    
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        
        let rooms = roomVM.currRooms
        VStack {
            ToolbarView(title: "Spaces")
                .padding(.top)
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 20) {
                    ForEach(rooms, id: \.self) { room in
                        NavigationLink(destination: PlantView(room: room)) {
                            RoomCard(room: room)
                        }
                    }
                }
            }.padding(.horizontal)
            
            Spacer()
            Button("New Room") {
                self.showNewRoom.toggle()
            }
                .buttonStyle(LongGreenButton())
                .sheet(isPresented: $showNewRoom) {
                    NewRoomView()
                }
            
        }.onAppear(perform: {
            roomVM.getData()
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}
