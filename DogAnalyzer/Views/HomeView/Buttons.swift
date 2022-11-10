//
//  Buttons.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct Buttons: View {
    @EnvironmentObject var model: ContentModel
    @Binding var activeSheet: ActiveSheet?
    @Binding var sourceType: UIImagePickerController.SourceType?
    
    let geometry: GeometryProxy
    
    var body: some View {
        
        VStack {
            ZStack {
                
                // Center button
                HStack {
                    // Main Camera Image
                    Button(action: {
                        model.setLoadingTrue()
                        self.sourceType = .camera
                        activeSheet = .isImagePickerDisplay
                        
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/4.5, height: geometry.size.height/4.5)
                                .modifier(ButtonBackgroundColorStyle())
                            Circle()
                                .frame(width: geometry.size.width/5, height: geometry.size.height/5)
                                .foregroundColor(.yellow)
                            
                            Image(systemName: "camera")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    })
                    .disabled(model.loading)
                }
                
                // Left side buttons
                HStack(alignment: .center, spacing: 30) {
                    // Photo selector Button
                    Button(action: {
                        model.setLoadingTrue()
                        self.sourceType = .photoLibrary
                        activeSheet = .isImagePickerDisplay
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/9, height: geometry.size.height/9)
                                .foregroundColor(.yellow)
                            
                            Image(systemName: "photo")
                                .font(.title2)
                        }
                    })
                    .disabled(model.loading)
                }
                .padding(.trailing, 130)
                
                // Right side buttons
                HStack(alignment: .center, spacing: 30) {
                    
                    Spacer()
                    
                    // Random Image Button
                    Button(action: {
                        model.setLoadingTrue()
                        model.setNewBreed(selectedBreed: typeOfBreeds.randomElement()!)
                        //model.getDogData()
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/9, height: geometry.size.height/9)
                                .foregroundColor(.yellow)
                            
                            Image(systemName: "shuffle")
                                .font(.title2)
                        }
                    })
                    .disabled(model.loading)
                    
                    // Setting preferences button
                    Button(action: {
                        activeSheet = .showOptionMenu
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/9, height: geometry.size.height/9)
                                .foregroundColor(.clear)
                            
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                        }
                        
                    })
                    .disabled(model.loading)
                    
                }
                .padding(.trailing, 35)
                
            }
  
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        
    }
}
