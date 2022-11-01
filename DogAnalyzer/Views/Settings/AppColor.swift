//
//  AppColor.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import SwiftUI

struct AppColor: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        List {
            
            Section {
                Button {
                    model.setNewAppColor(color: .light)
                    UserDefaults.standard.set(AppColorSelection.light.rawValue, forKey: "colorSelection")
                } label: {
                    HStack {
                        Text("Light")
                        Spacer()
                        if model.colorSelection == .light {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .modifier(ListCellColorStyle())
            } footer: {
                Text("The default app setting. Follows light system theme")
            }
            
            Section {
                Button {
                    model.setNewAppColor(color: .system)
                    // Save user selection into memory
                    UserDefaults.standard.set(AppColorSelection.system.rawValue, forKey: "colorSelection")
                } label: {
                    HStack {
                        Text("System")
                        Spacer()
                        if model.colorSelection == .system {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .modifier(ListCellColorStyle())
            } footer: {
                Text("Follow your device appearance settings")
            }
            
            Section {
                Button {
                    model.setNewAppColor(color: .dark)
                    UserDefaults.standard.set(AppColorSelection.dark.rawValue, forKey: "colorSelection")
                } label: {
                    HStack {
                        Text("Dark")
                        Spacer()
                        if model.colorSelection == .dark {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .modifier(ListCellColorStyle())
                
            } footer: {
                Text("Force dark mode to the entire app")
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("App Color")
                    .font(.headline)
            }
        }
        .scrollContentBackground(.hidden)
        .modifier(TextColorStyle())
        .modifier(BackgroundColorStyle())
        
    }
}

struct AppColor_Previews: PreviewProvider {
    static var previews: some View {
        AppColor()
    }
}
