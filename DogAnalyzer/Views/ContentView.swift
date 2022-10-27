//
//  ContentView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ContentModel
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @State var showDetailView = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0.0) {
            
            GeometryReader { geo in
                
                TabView() {
                    
                    VStack {
                        
                        Button {
                            showDetailView = true
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color("AdaptiveBackground"))
                                
                                if model.loading {
                                    ProgressView()
                                } else {
                                    Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage())
                                        .resizable()
                                        .frame(alignment: .leading)
                                        .scaledToFill()
                                        .clipped()
                                    
                                    Text(model.identifier ?? titleErrorMessage)
                                        .frame(
                                            width: geo.size.width - 40,
                                            height: geo.size.height - 80,
                                            alignment: .bottomLeading
                                        )
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding([.leading, .bottom], 20)
                                }
                                
                            }
                            .frame(
                                width: geo.size.width - 40,
                                height: geo.size.height - 50,
                                alignment: .center
                            )
                            .cornerRadius(15)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showDetailView) {
                            DogDetailView()
                        }
                        
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
            .onAppear(perform: model.getDogData)
            .opacity(model.imageData == nil ? 0 : 1)
            
            // Buttons
            HStack(spacing: 30) {
                
                Button(action: {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                    
                }, label: {
                    Image(systemName: "camera")
                })
                .disabled(model.loading)
                
                Button(action: {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }, label: {
                    Image(systemName: "photo")
                })
                .disabled(model.loading)
                
                Spacer()
                
                Button(action: {
                    model.getDogData()
                }, label: {
                    Text("Random")
                        .bold()
                })
                .disabled(model.loading)
            }
            .padding(.horizontal, 30)
            
        }
        .sheet(isPresented: self.$isImagePickerDisplay, onDismiss: {
            if selectedImage != nil {
                ContentModel(image: selectedImage!.pngData())
            }
        }) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        
    }
    
}
