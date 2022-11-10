//
//  MainImage.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct MainImage: View {
    @EnvironmentObject var model: ContentModel
    @Binding var activeSheet: ActiveSheet?
    
    let geometry: GeometryProxy
    
    var body: some View {
        
        TabView() {
            VStack {
                
                // Main image
                Button {
                    if model.shuffleMode {
                        activeSheet = .showDogShuffleView
                    } else {
                        activeSheet = .showDetailView
                    }

                } label: {
                    ZStack {
                        Rectangle()
                        
                        if model.loading {
                            ProgressViewCustom(geometry: geometry)
                        } else {
                            Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage() )
                                .resizable()
                                .frame(alignment: .leading)
                                .scaledToFill()
                                .clipped()
                                .overlay(alignment: .bottom) {
                                    Text(model.identifier?.capitalized ?? titleErrorMessage)
                                        .foregroundColor(.white)
                                        .frame(
                                            width: geometry.size.width - 40,
                                            alignment: .bottomLeading
                                        )
                                        .shadow(radius: 10)
                                        .font(.largeTitle)
                                        .bold()
                                        .padding([.leading, .bottom, .top], 30)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.yellow]), startPoint: .top, endPoint: .bottom).frame(height: 200)
                                        )
                                }
                            
                        }
                        
                    }
                    .frame(
                        width: geometry.size.width - 40,
                        height: geometry.size.height - 165,
                        alignment: .center
                    )
                    .cornerRadius(15)
                }
                .disabled(model.loading)
                .buttonStyle(PlainButtonStyle())
                .sheet(item: $activeSheet, onDismiss: {
                    model.setLoadingFalse()
                }, content: { item in
                    if item == .showDetailView {
                        DogDetailView()
                    } else {
                        DogShuffleView()
                    }
                })
                
            }
            
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .shadow(
            color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.65),
            radius: 10,
            x: -5,
            y: 5
        )
        
    }
}
