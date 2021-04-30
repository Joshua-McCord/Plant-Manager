//
//  PlantSearchView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI

struct PlantSearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var searchText = ""
    @State private var showGoButton: Bool = false
    
    @ObservedObject var searchVM = PlantSearchViewModel()
    
    
    var body: some View {
        let searchResults = searchVM.searchList
        VStack {
            ZStack {
                ToolbarView(title: "Search")
                    .padding(.top)
                Button("<") {
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(SmallBackButton())
                .offset(x: -145.0, y: 20.0)
            }
            // Search view
            HStack {
                VStack {
                    HStack {
                        Image("search-flower")
                            .scaleEffect(1.5)

                        TextField("Enter plant name...", text: $searchText, onEditingChanged: { isEditing in
                                self.showGoButton = true
                        }, onCommit: {
                            searchVM.searchForPlants(plantName: searchText)
                        })
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.leading, 10)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                                .foregroundColor(.secondary)
                        }
                    }
                    Divider()
                        .background(Color.black)
                        .padding(.vertical, 2)
                }
                .padding(.leading)
                
                if self.showGoButton && self.searchText != "" {
                    Button("Go") {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        
                        searchVM.searchForPlants(plantName: searchText)
                    }
                    .buttonStyle(LongGreenButton())
                    .padding(.horizontal)
                    
                } else {
                    Button("Go"){}
                        .buttonStyle(LongGreenButton())
                        .padding(.horizontal)
                        .opacity(0.5)
                }
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .navigationBarHidden(self.showGoButton)
            
            // Make each plant in search result list clickable
            // and add it to the users plants.
            List {
                ForEach(searchResults, id:\.self) {
                    searchResult in //Text(searchResult)
                    Button(action: {
                        searchVM.addPlant(plantSearchResult: searchResult)
                    }) {
                        Text(searchResult.plantName)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.trailing)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .resignKeyboardOnDragGesture()
    }
}

#if DEBUG
struct PlantSearchPreview: PreviewProvider {
    static var previews: some View {
        PlantSearchView()
    }
}
#endif
