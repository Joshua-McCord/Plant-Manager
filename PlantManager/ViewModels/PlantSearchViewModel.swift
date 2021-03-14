//
//  PlantSearchViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON


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
                switch response.result {
                    case .success(let value) :
                        //print(JSON(value))
                        let json = JSON(value)
                        self.parseJSON(json: json)
                        
                    case .failure(_):
                        print("failure")
                }
                
            }
    }
    
    func parseJSON(json: JSON) {
        var plantId: Int = -1
        if json["data"].array!.count != 0 {
            //print("Plant ID > \(json["data"][0]["id"])")
            plantId = json["data"][0]["id"].intValue
            
        }
        if(plantId != -1) {
            print(plantId)
            addData(trefleId: String(plantId))
        }
        else { print("failed")}
    }
    
    func addData(trefleId: String) {
        let tmpToken: String? = User.sharedInstance.idToken
        guard let token = tmpToken else {return }
        let url = URL(string: "https://us-central1-house-plants-api.cloudfunctions.net/webApi/api/v1/plants")!
        
        // prepare json data
        let post = PlantPost(name: "Ivy 4", waterAt: "1:00",roomId: "123" ,treflePlantId: trefleId)
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
    
}
