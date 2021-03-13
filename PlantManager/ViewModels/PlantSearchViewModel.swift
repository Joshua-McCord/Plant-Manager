//
//  PlantSearchViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import Alamofire
//import TrefleSwiftSDK


class PlantSearchViewModel : ObservableObject {
    
    init () {
        
    }
    
    func addPlant(plant: String)  {
        let par = ["q" : plant]
        
        AF.request("https://trefle.io/api/v1/plants/search?token=_SsZd0R46iCZ5QF9zHP9eyeONarcvEvU5CsO-fOfRIg",
                   method: .get,
                   parameters: par,
                   encoder: URLEncodedFormParameterEncoder.default)
            .cURLDescription { description in
                //print(description)
            }.responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                        case 200:
                            print("example success")
                        default:
                            print("Trefle error with response status: \(status)")
                    }
                }
                do {
                    // parse json reponse here
                    print("Trefle Success")
                } catch {
                    print("json error")
                }
                
            }
    }
    
}
