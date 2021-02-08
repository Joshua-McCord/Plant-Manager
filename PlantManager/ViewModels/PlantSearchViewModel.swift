//
//  PlantSearchViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
//import TrefleSwiftSDK


class PlantSearchViewModel : ObservableObject {
    
    func getJson() -> String {
        let urlString = "https://trefle.io/api/v1/plants/?token=_SsZd0R46iCZ5QF9zHP9eyeONarcvEvU5CsO-fOfRIg"
        if let url = URL(string: urlString)
        {
            URLSession.shared.dataTask(with: url) { data, res, err in
                if let data = data {
                    print("hey")
                    print("JSON String: \(String(data: data, encoding: .utf8))")
                    
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Plant.self, from: data) {
                        print(json)
                    }
                }
            }.resume()
        }
        return "test"
    }
    
}
