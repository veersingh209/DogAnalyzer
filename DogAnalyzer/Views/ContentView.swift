//
//  ContentView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case showDetailView,
         showOptionMenu,
         isImagePickerDisplay
    
    var id: String {
        "hash"
    }
}

struct ContentView: View {
    @EnvironmentObject var model: ContentModel
    
    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var selectedImage: UIImage?
    @State private var activeSheet: ActiveSheet?
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0.0) {
            
            GeometryReader { geo in
                
                HStack {
                    Spacer()
                    Text("DogAnalyzer")
                        .font(.title)
                    Spacer()
                }
                
                TabView() {
                    
                    VStack {
                        
                        Button {
                            activeSheet = .showDetailView
                        } label: {
                            ZStack {
                                Rectangle()
                                
                                if model.loading {
                                    ProgressView()
                                    .scaleEffect(2)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                                } else {
                                    Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage())
                                        .resizable()
                                        .frame(alignment: .leading)
                                        .scaledToFill()
                                        .clipped()
                                    
                                    Text(model.identifier ?? titleErrorMessage)
                                        .frame(
                                            width: geo.size.width - 40,
                                            height: geo.size.height - 185,
                                            alignment: .bottomLeading
                                        )
                                        .shadow(radius: 10)
                                        .font(.largeTitle)
                                        .bold()
                                        .padding([.leading, .bottom], 20)
                                }
                                
                            }
                            .frame(
                                width: geo.size.width - 40,
                                height: geo.size.height - 135,
                                alignment: .center
                            )
                            .cornerRadius(15)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(item: $activeSheet, onDismiss: {
                            model.setLoadingFalse()
                        }, content: { item in
                            if item == .showDetailView {
                                DogDetailView()
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
                
                .opacity(model.imageData == nil ? 0 : 1)
                
                // Bottom Buttons
                VStack {
                    ZStack(alignment: .center) {
                        
                        Circle()
                            .frame(width: geo.size.width/5, height: geo.size.height/5)
                        Circle()
                            .frame(width: geo.size.width/6, height: geo.size.height/6)
                            .foregroundColor(.yellow)
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Button(action: {
                                model.setLoadingTrue()
                                self.sourceType = .camera
                                activeSheet = .isImagePickerDisplay
                                
                            }, label: {
                                Image(systemName: "camera")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            })
                            .disabled(model.loading)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                model.setLoadingTrue()
                                self.sourceType = .photoLibrary
                                activeSheet = .isImagePickerDisplay
                            }, label: {
                                Image(systemName: "photo")
                            })
                            .padding(.trailing)
                            Spacer()
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Spacer()
                            
                            Button(action: {
                                model.setLoadingTrue()
                                model.getDogData()
                            }, label: {
                                Image(systemName: "shuffle")
                                    .bold()
                            })
                            .padding(.leading)
                            .disabled(model.loading)
                            Spacer()
                        }

                        HStack {
                            Spacer()
                            
                            Button(action: {
                                activeSheet = .showOptionMenu
                            }, label: {
                                Image(systemName: "ellipsis.circle")
                                    .bold()
                                    .rotationEffect(.degrees(-90))
                            })
                            .padding()
                            .padding(.trailing)
                            .disabled(model.loading)
                        }
                    }
                    
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                
            }
        }
        .modifier(TextColorStyle())
        .modifier(BackgroundColorStyle())
        .sheet(item: $activeSheet, onDismiss: {
            model.setLoadingFalse()
        }, content: { item in
            switch item {
            case .showDetailView:
                DogDetailView()
            case .showOptionMenu:
                SettingsMainMenu()
            case .isImagePickerDisplay:
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.$sourceType)
                    .onDisappear {
                        if selectedImage != nil {
                            self.model.newCameraImage(image: selectedImage!.pngData())
                        }
                    }
            }
        })
        
    }
}
