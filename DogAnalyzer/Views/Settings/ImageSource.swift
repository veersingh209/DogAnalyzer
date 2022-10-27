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
                    model.imageSelection = .allSources
                } label: {
                    HStack {
                        Text("All Sources")
                            .foregroundColor(Color("AdaptiveText"))
                        Spacer()
                        if model.imageSelection == .allSources {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            } footer: {
                Text("Use a combination of all the sources available")
            }
            
            Section {
                Button {
                    model.imageSelection = .dogCEO
                } label: {
                    HStack {
                        Text("DogCEO")
                            .foregroundColor(Color("AdaptiveText"))
                        Spacer()
                        if model.imageSelection == .dogCEO {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
            } footer: {
                Text("The internet's biggest collection of open source dog pictures. (dog.ceo/api)")
            }
            
            
            Section {
                Button {
                    model.imageSelection = .dopAPI
                } label: {
                    HStack {
                        Text("TheDogAPI")
                            .foregroundColor(Color("AdaptiveText"))
                        Spacer()
                        if model.imageSelection == .dopAPI {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
            } footer: {
                Text("The Dog API, publice service API all about dogs. Wokring on the free platform. (thedogapi.com)")
            }
            
        }
        .navigationTitle("Dog Image Source")
        
    }
}

struct ImageSource_Previews: PreviewProvider {
    static var previews: some View {
        ImageSource()
    }
}
