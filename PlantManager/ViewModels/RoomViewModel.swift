//
//  RoomViewModel.swift
//  PlantManager
//
//  Created by Daniella Ruzinov on 4/30/21.
//

import Foundation
import Alamofire
import SwiftyJSON


class RoomViewModel : ObservableObject {
    
    @Published var currRooms: [Room] = []
    
    
    func getcurrRooms() -> [Room] {
        return currRooms
    }
    
    func getData() {
        // Generate the Correct headers for the GET request
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(User.sharedInstance.idToken)",
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        // Use AlamoFire to fire request
        AF.request("https://us-central1-house-plants-api.cloudfunctions.net/webApi/api/v1/rooms",
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
                        self.currRooms.removeAll()
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
                
                let room: Room = Room(
                    rid: json["data"][index]["id"].string,
                    name: json["data"][index]["data"]["name"].string,
                    roomIconId: json["data"][index]["data"]["roomIconId"].int
                )
                currRooms.append(room)
            }
        }
    }
    
    func addRoom(roomName: String?, roomIcon: Int?)  {
        let tmpToken: String? = User.sharedInstance.idToken
        guard let token = tmpToken else {return }
        let url = URL(string: "https://us-central1-house-plants-api.cloudfunctions.net/webApi/api/v1/rooms")!
        
        // prepare json data
        let post = RoomPost(name: roomName ?? "New Room", roomIconId: roomIcon ?? 0)
        
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
