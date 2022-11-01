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
            ZStack(alignment: .center) {
                
                // Main Camera Image
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        model.setLoadingTrue()
                        self.sourceType = .camera
                        activeSheet = .isImagePickerDisplay
                        
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: geometry.size.width/5, height: geometry.size.height/5)
                                .modifier(ButtonBackgroundColorStyle())
                            Circle()
                                .frame(width: geometry.size.width/6, height: geometry.size.height/6)
                                .foregroundColor(.yellow)
                            
                            Image(systemName: "camera")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    })
                    .disabled(model.loading)
                    Spacer()
                }
                
                // Photo selector Button
                HStack {
                    Spacer()
                    
                    Button(action: {
                        model.setLoadingTrue()
                        self.sourceType = .photoLibrary
                        activeSheet = .isImagePickerDisplay
                    }, label: {
                        Image(systemName: "photo")
                            .font(.title2)
                    })
                    .padding(.trailing, 30)
                    .padding(.top)
                    Spacer()
                    Spacer()
                }
                
                // Random Image Button
                HStack {
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        model.setLoadingTrue()
                        model.getDogData()
                    }, label: {
                        Image(systemName: "shuffle")
                            .font(.title2)
                    })
                    .padding(.leading, 30)
                    .padding(.top)
                    .disabled(model.loading)
                    Spacer()
                }
                // Setting preferences button
                HStack {
                    Spacer()
                    Button(action: {
                        activeSheet = .showOptionMenu
                    }, label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                    })
                    .padding(.trailing, 30)
                    .padding(.top)
                    .disabled(model.loading)
                }
                
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        
    }
}
