//
//  LogInViewModel.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/5/21.
//

import Foundation
import Alamofire

class LogInViewModel: ObservableObject{
    
    var user = User.sharedInstance
    
    @Published var username:String? = nil
    @Published var password:String? = nil
    @Published var isValid:Bool = false
    
    func attemptLogIn() {
        struct Login: Encodable {
            let email: String
            let password: String
            let returnSecureToken: Bool
        }
        
        let login = Login(email: username ?? "nil", password: password ?? "nil", returnSecureToken: true)
        
        
        
        AF.request("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCFddJfh8J5VIdborNrqsyHbcIdXd2hDYc",
                   method: .post,
                   parameters: login,
                   encoder: URLEncodedFormParameterEncoder.default)
            .cURLDescription { description in
            }.responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                        case 200:
                            print("example success")
                            self.isValid = true
                        default:
                            print("error with response status: \(status)")
                    }
                }
                do {
                    let decoder = JSONDecoder()
                    User.sharedInstance = try decoder.decode(User.self, from: response.data ?? Data())
                    debugPrint(response.data!)
                } catch {
                    print("json error")
                }
                
                }
            }
    }
    
