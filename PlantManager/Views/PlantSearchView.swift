//
//  PlantSearchView.swift
//  PlantManager
//
//  Created by Joshua Cole McCord on 2/4/21.
//

import Foundation
import SwiftUI
import Combine

struct PlantSearchView: View {
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    @ObservedObject var searchVM = PlantSearchViewModel()
    
    
    var body: some View {
        let searchResults = searchVM.searchList
        NavigationView {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        
                        // When pressing enter, queries the viewmodel to
                        // search Trefle Database for keyword
                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            searchVM.searchForPlants(plantName: searchText)
                        }).foregroundColor(.primary)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    if showCancelButton  {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton)
                
                
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
                .navigationBarTitle(Text("Search"))
                .resignKeyboardOnDragGesture()
            }
        }
    }
}



