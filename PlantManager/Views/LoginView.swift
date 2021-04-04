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
        VStack {
            VStack {
                HStack {
                    Text("Email").frame(width: 75, alignment: .leading)
                    TextField("email", text: Binding<String>(
                            get: {self.viewModel.username ?? ""},
                            set: {self.viewModel.username = $0}
                    ))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                Divider()
                    .background(Color.black)
                    .padding(.bottom)
                HStack {
                    Text("Password").frame(width: 75, alignment: .leading)
                    TextField("password", text: Binding<String>(
                                get: {self.viewModel.password ?? ""},
                                set: {self.viewModel.password = $0}
                    ))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                }
                Divider()
                    .background(Color.black)
            }.padding(.bottom, 40)
            Button("Sign In") {
                viewModel.attemptLogIn()
            }.buttonStyle(LongGreenButton())
            
            NavigationLink(destination: MainView(), isActive: $viewModel.isValid) { EmptyView() }
        }
    }
}

#if DEBUG
struct LoginPreview: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
