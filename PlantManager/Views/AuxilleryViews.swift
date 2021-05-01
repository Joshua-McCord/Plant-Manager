//
//  AuxilleryViews.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct PlantCard: View {
    var plant: Plant
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Image("golden-pothos")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 170, alignment: .center)
                    .clipShape(Rectangle())
                    .cornerRadius(14)
                
                ZStack {
                    Rectangle()
                        .fill(Color("Primary"))
                        .frame(width: 150, height: 65, alignment: .bottom)
                        .cornerRadius(14)
                    
                    Text(plant.name ?? "Plant")
                        .font(Font.custom("SFProText-Regular", size: 18.0))
                        .foregroundColor(.black)
                    
                }.offset(x: 0, y: 60)
                
                
            }.padding()
        }.modifier(CardModifier())

    }
}

struct RoomCard: View {
    private var room: Room
    private var iconDict = [0: "chair", 1: "bathtub", 2: "bed", 3: "dining", 4: "living-room", 5: "tv"]
    
    init(room: Room) {
        self.room = room
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color("Primary"))
                .frame(width: 150, height: 170, alignment: .bottom)
                .cornerRadius(14)
            
            VStack {
                Image(iconDict[room.roomIconId ?? 0] ?? "chair") // check on size
                
                Text(room.name ?? "Room")
                    .font(Font.custom("SFProText-Regular", size: 18.0))
                    .foregroundColor(.black)
            }
        }
        .modifier(CardModifier())
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(14)
            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 4, y: 8)
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

struct ToolbarView: View {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(self.title)
                .font(Font.custom("Futura-Medium", size: self.title.count > 9 ? 48.0 : 64.0))
                .padding(1)
            Capsule()
                .fill(Color("Primary"))
                .frame(width: 130, height: 12)
        }
    }
}

struct LongGreenButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.horizontal)
            .padding(.vertical, 8)
            .font(Font.custom("Futura-medium", size: 20.0))
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("Accent"))
            )
        
    }
}

struct SmallBackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(10)
            .font(Font.custom("Futura-bold", size: 12.0))
            .foregroundColor(.white)
            .background(
                Circle()
                    .fill(Color("Accent"))
            )
        
    }
}

struct BigBackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.horizontal)
            .padding(.vertical, 8)
            .font(Font.custom("Futura-medium", size: 20.0))
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("Primary"))
            )
        
    }
}
