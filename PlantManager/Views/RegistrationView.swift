//
//  RegistrationView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/5/21.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    @ObservedObject var viewModel = RegistrationViewModel()
    
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
            Button("Create Account") {
                viewModel.attemptRegistration()
            }.buttonStyle(LongGreenButton())
            
            NavigationLink(destination: AboutUsView(), isActive: $viewModel.registrationComplete) { EmptyView() }
        }
    }
}

#if DEBUG
struct RegistrationPreview: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
#endif
