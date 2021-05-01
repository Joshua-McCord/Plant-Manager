//
//  NewRoomView.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/30/21.
//

import SwiftUI

struct NewRoomView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var roomName = ""
    @State private var selection = -1
    @ObservedObject private var roomViewModel = RoomViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Text("New Space")
                    .font(Font.custom("Futura-Medium", size: 36.0))
                    .padding()
                Text("Give your space a name!")
                    .font(Font.custom("SFProText-Regular", size: 18.0))
            
                HStack {
                    TextField("Space name", text: $roomName)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    
                    Button(action: {
                        self.roomName = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(self.roomName == "" ? 0 : 1)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(.white))
                .padding(.horizontal, 40)
                .padding(.top, 5)
                
                VStack {
                    Text("Select an icon:")
                        .font(Font.custom("SFProText-Regular", size: 18.0))
                    HStack {
                        Button(action: {
                                self.selection = 0
                        }) {
                            Image("chair")
                                .opacity(self.selection == 0 ? 1 : 0.5)
                        }
                            .padding(5)
                        Button(action: {self.selection = 1}) {
                            Image("bathtub")
                                .opacity(self.selection == 1 ? 1 : 0.5)
                        }
                            .padding(5)
                        Button(action: {self.selection = 2}) {
                            Image("bed")
                                .opacity(self.selection == 2 ? 1 : 0.5)
                        }
                            .padding(5)
                    }
                    HStack {
                        Button(action: {self.selection = 3}) {
                            Image("dining")
                                .opacity(self.selection == 3 ? 1 : 0.5)
                        }
                            .padding(5)
                        Button(action: {self.selection = 4}) {
                            Image("living-room")
                                .opacity(self.selection == 4 ? 1 : 0.5)
                        }
                            .padding(5)
                        Button(action: {self.selection = 5}) {
                            Image("tv")
                                .opacity(self.selection == 5 ? 1 : 0.5)
                        }
                            .padding(5)
                    }
                }
                .padding(.top)
                
                HStack {
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(LongGreenButton())
                    if roomName == "" {
                        Button("Done") {}
                            .buttonStyle(LongGreenButton())
                            .opacity(0.5)
                    } else {
                        Button("Done") {
                            roomViewModel.addRoom(roomName: self.roomName, roomIcon: self.selection)
                            roomViewModel.getData()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .buttonStyle(LongGreenButton())
                    }
                }
                .padding()
            }
            .background(
                Rectangle()
                    .fill(Color("Primary"))
                    .cornerRadius(14)
            )
            .padding(35)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .resignKeyboardOnDragGesture()
    }
}
