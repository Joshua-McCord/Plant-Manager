//
//  DetailViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 4/3/21.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

class DetailViewModel : ObservableObject {
    
    let plant: Plant
    
    init(plant: Plant) {
        self.plant = plant;
    }
    
    func getPlantName() -> String {
        return plant.name!
    }
    
    func getPlantWaterAt() -> String {
        return plant.waterAt!
    }
    
    func getPlantInformation() {
        let treflePlantId = plant.treflePlantId
        let par = ["q" : treflePlantId]
        
        //var name: String? = plant.treflePlantId
        if let unwrapped = treflePlantId {
            print("\(unwrapped) letters")
            AF.request("https://trefle.io/api/v1/plants/\(unwrapped)?token=_SsZd0R46iCZ5QF9zHP9eyeONarcvEvU5CsO-fOfRIg",
                       method: .get,
                       parameters: par,
                       encoder: URLEncodedFormParameterEncoder.default)
                .cURLDescription { description in
                    //print(description)
                }.responseJSON { response in
                    //print(response)
                    //to get status code
                    if let status = response.response?.statusCode {
                        switch(status){
                            case 200:
                                print("example success")
                            default:
                                print("Trefle error with response status: \(status)")
                        }
                    }
                    switch response.result {
                        case .success(let value) :
                            //print(JSON(value))
                            let json = JSON(value)
                            self.parsePlantInformation(json: json)
                            
                        case .failure(_):
                            print("failure")
                    }
                }
        } else {
            print("Missing name.")
        }
    }
    
    func parsePlantInformation(json: JSON) {
        print(json);
        
    }
    
}
    

