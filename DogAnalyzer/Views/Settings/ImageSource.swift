//
//  ImageSource.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/27/22.
//

import SwiftUI

struct ImageSource: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
                
        List {
            
            Section {
                Button {
                    model.setImageSource(source: .dogCEO)
                    UserDefaults.standard.set(SourceImageSelection.dogCEO.rawValue, forKey: "sourceSelection")
                } label: {
                    HStack {
                        Text("DogCEO")
                        Spacer()
                        if model.imageSelection == .dogCEO {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .modifier(ListCellColorStyle())
                
            } footer: {
                Text("The internet's biggest collection of open source dog pictures. (dog.ceo/api)")
            }
            
            
            Section {
                Button {
                    model.setImageSource(source: .dogAPI)
                    UserDefaults.standard.set(SourceImageSelection.dogAPI.rawValue, forKey: "sourceSelection")
                } label: {
                    HStack {
                        Text("TheDogAPI")
                        Spacer()
                        if model.imageSelection == .dogAPI {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .modifier(ListCellColorStyle())
                
            } footer: {
                Text("The Dog API, publice service API all about dogs. Wokring on the free platform. (thedogapi.com)")
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Image Source")
                    .font(.headline)
            }
        }
        .scrollContentBackground(.hidden)
        .modifier(TextColorStyle())
        .modifier(BackgroundColorStyle())
        
    }
}

struct ImageSource_Previews: PreviewProvider {
    static var previews: some View {
        ImageSource()
    }
}
