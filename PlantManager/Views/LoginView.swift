//
//  LoginView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LogInViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack() {
                    Text("Plant Manager")
                    VStack(alignment: .leading, spacing: 15) {
                    
                        TextField("username", text: Binding<String>(
                                    get: {self.viewModel.username ?? ""},
                                    set: {self.viewModel.username = $0}))
                            .padding()
                            .cornerRadius(20.0)
                    
                        TextField("password", text: Binding<String>(
                                    get: {self.viewModel.password ?? ""},
                                    set: {self.viewModel.password = $0}))
                            .padding()
                            .cornerRadius(20.0)
                    }.padding([.leading, .trailing], 27.5)
                    
                    Button(action: {
                        viewModel.attemptLogIn()
                    }, label: {
                        Text("Sign In")
                            .fontWeight(.semibold)
                            .font(.title)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.init(hex: "ECBEB4"))
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.init(hex: "ECBEB4"))
                    .cornerRadius(40)
                    .padding(.horizontal, 40)
                    NavigationLink(destination: MainView(), isActive: $viewModel.isValid) { EmptyView() }
                    
                    NavigationLink(destination: RegistrationView()) {
                        Text("Register")
                            .fontWeight(.semibold)
                            .font(.title)
                            
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.init(hex: "ECBEB4"))
                            .cornerRadius(40)
                            .padding(.horizontal, 40)
                    }
                }
            }
        }
    }
}

