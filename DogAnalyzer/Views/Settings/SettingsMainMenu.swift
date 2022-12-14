//
//  SettingsMainMenu.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import SwiftUI

struct SettingsMainMenu: View {
    
    var body: some View {
        
        NavigationView {
            
            List {
                Section {
                    NavigationLink {
                        AppColor()
                    } label: {
                        Text("App Color")
                    }
                    .modifier(ListCellColorStyle())
                } header: {
                    Text("Theme")
                } footer: {
                    Text("Change the app color scheme. Defaults to match device settings")
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("App Settings")
                        .font(.headline)
                }
            }
            .scrollContentBackground(.hidden)
            .modifier(TextColorStyle())
            .modifier(BackgroundColorStyle())
        }
        
    }
}

struct SettingsMainMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMainMenu()
    }
}
