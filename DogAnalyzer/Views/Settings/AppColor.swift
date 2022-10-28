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
                        model.setNewAppColor(color: .system)
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
                    
                    Button {
                        model.setNewAppColor(color: .dark)
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
                    
                    Button {
                        model.setNewAppColor(color: .light)
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
                    Text("Change the app color scheme. Defaults to match device settings")
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
