//
//  RoomViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON

//FIXME: Convert all URL requests to AlamoFire requests

class RoomViewModel : ObservableObject {
    
    //Reactive UI
    @Published var currPlants: [Plant] = []
    
    
    func getCurrPlants() -> [Plant] {
        return currPlants
    }
    
    //FIXME Move this to New Plant ViewModel and Convert to AlamoFire
    func addData() {
        let tmpToken: String? = User.sharedInstance.idToken
        guard let token = tmpToken else {return }
        let url = URL(string: "https://us-central1-house-plants-api.cloudfunctions.net/webApi/api/v1/plants")!
        
        // prepare json data
        let post = PlantPost(name: "Ivy", waterAt: "1:00", roomId: "123" ,treflePlantId: "123456")
        //let json: PlantPost = post
        
        //let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(post)
        print(String(data: data, encoding: .utf8)!)
        
        // create post request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        //debugPrint("Request > \(request.httpBody)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                debugPrint(responseJSON)
            }
        }
        task.resume()
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
                //print(description)
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
