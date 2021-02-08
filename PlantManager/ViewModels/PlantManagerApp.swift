//
//  PlantManagerApp.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/2/21.
//

import SwiftUI
//import TrefleSwiftSDK

@main
struct PlantManagerApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Override point for customization after application launch. Here you can out the code you want.
        //Trefle.configure(accessToken: "_SsZd0R46iCZ5QF9zHP9eyeONarcvEvU5CsO-fOfRIg", uri: "PlantManager://")
        return true
    }
}
