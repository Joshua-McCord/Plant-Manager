//
//  RegistrationViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/5/21.
//

import Foundation
import Alamofire

class RegistrationViewModel: ObservableObject {
    @Published var username:String? = nil
    @Published var password:String? = nil
    @Published var registrationComplete:Bool = false
    
    func attemptRegistration() {
        struct Login: Encodable {
            let email: String
            let password: String
            let returnSecureToken: Bool = true
        }
        
        let login = Login(email: username ?? "nil", password: password ?? "nil")
        
        AF.request("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCFddJfh8J5VIdborNrqsyHbcIdXd2hDYc",
                   method: .post,
                   parameters: login,
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
                            self.registrationComplete = true
                        default:
                            print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.data {
                    //let JSON = result as! NSDictionary
                    print("result = \(result)")
                }
                
            }
    }
}
