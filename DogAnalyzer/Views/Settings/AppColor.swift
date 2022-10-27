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
                    model.colorSelection = .system
                } label: {
                    HStack {
                        Text("System")
                            .foregroundColor(Color("AdaptiveText"))
                        Spacer()
                        if model.colorSelection == .system {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    model.colorSelection = .dark
                } label: {
                    HStack {
                        Text("Dark")
                            .foregroundColor(Color("AdaptiveText"))
                        Spacer()
                        if model.colorSelection == .dark {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button {
                    model.colorSelection = .light
                } label: {
                    HStack {
                        Text("Light")
                            .foregroundColor(Color("AdaptiveText"))
                        Spacer()
                        if model.colorSelection == .light {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
            } footer: {
                Text("Change the app color scheme. Defaults to match device settings")
            }
            
        }
        .navigationTitle("App Color")
        
    }
}

struct AppColor_Previews: PreviewProvider {
    static var previews: some View {
        AppColor()
    }
}
