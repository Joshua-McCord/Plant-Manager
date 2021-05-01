//
//  PlantSearchViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine


class PlantSearchViewModel : ObservableObject {
    
    @Published var searchList: [PlantSearchResult] = []
    
    func getSearchResults() -> [PlantSearchResult] {
        return searchList
    }
    
    func searchForPlants(plantName: String) {
        let par = ["q" : plantName]
        
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
                        self.parseSearchResultJSON(json: json)
                        
                    case .failure(_):
                        print("failure")
                }
            }
    }
    
    // Parse the search result from the Trefle Database and add to SearchResult list
    func parseSearchResultJSON(json: JSON) {
        
        if json["data"].array!.count != 0 {
            let numOfResults = json["meta"]["total"].intValue
            self.searchList .removeAll();
            for i in 0..<numOfResults {
                if(json["data"][i]["common_name"].string != nil) {
                    self.searchList.append(
                        PlantSearchResult(plantName: json["data"][i]["common_name"].stringValue,
                                          treflePlantID: String(json["data"][i]["id"].intValue)))
                }
            }
        }
    }
    
    // Add plant to user's database
    func addPlant(plantSearchResult: PlantSearchResult, currRoomId: String)  {
        let tmpToken: String? = User.sharedInstance.idToken
        guard let token = tmpToken else {return }
        let url = URL(string: "https://us-central1-house-plants-api.cloudfunctions.net/webApi/api/v1/plants")!
        
        // prepare json data
        let post = PlantPost(name: plantSearchResult.plantName,
                             waterAt: "1:00",
                             roomId: currRoomId,
                             treflePlantId: plantSearchResult.treflePlantID,
                             hasConnectedDevice: "false")
        
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

struct PlantSearchResult : Hashable {
    let plantName: String
    let treflePlantID: String
    init (plantName: String, treflePlantID: String) {
        self.plantName = plantName
        self.treflePlantID = treflePlantID
    }
    
}
