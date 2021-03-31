//
//  RoomViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON


class RoomViewModel : ObservableObject {
    
    @Published var currPlants: [Plant] = []
    
    
    func getCurrPlants() -> [Plant] {
        return currPlants
    }
    
    func getData() {
        // Generate the Correct headers for the GET request
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(User.sharedInstance.idToken)",
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        // Use AlamoFire to fire request
        AF.request("https://us-central1-house-plants-api.cloudfunctions.net/webApi/api/v1/plants",
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.httpBody,
                   headers: headers)
            .cURLDescription { description in
            }.validate().responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                        case 200:
                            print("example success")
                        default:
                            print("error with response status: \(status)")
                    }
                }
                switch response.result {
                    case .success(let value) :
                        self.currPlants.removeAll()
                        //print(JSON(value))
                        let json = JSON(value)
                        self.parseJSON(json: json)
                        
                    case .failure(_):
                        print("failure")
                }
            }
    }
    
    
    func parseJSON(json: JSON) {
        if json["data"].array!.count != 0 {
            for index in 0...(json["data"].array!.count - 1) {
                
                let plant: Plant = Plant(
                    uid: json["data"][index]["data"]["uid"].string,
                    name: json["data"][index]["data"]["name"].string,
                    waterAt: json["data"][index]["data"]["waterAt"].string,
                    treflePlantId: json["data"][index]["data"]["treflePlantId"].string
                )
                currPlants.append(plant)
            }
        }
    }
}
