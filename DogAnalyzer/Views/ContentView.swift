//
//  ContentView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var imageModel: DogModel
    
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
                                    .foregroundColor(.white)
                                
                                Image(uiImage: UIImage(data: imageModel.dog.imageData ?? Data()) ?? UIImage())
                                    .resizable()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .scaledToFill()
                                    .clipped()
                                
                                Text(imageModel.dog.identifier)
                                    .frame(
                                        width: geo.size.width - 40,
                                        height: geo.size.height - 80,
                                        alignment: .bottomLeading
                                    )
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                                
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
                            ImageDetailView(model: imageModel)
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
            .onAppear(perform: imageModel.getDogs)
            .opacity(imageModel.dog.imageData == nil ? 0 : 1)
            
            // Buttons
            HStack(spacing: 0) {
                
                Button(action: {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                    
                }, label: {
                    Image(systemName: "camera")
                })
                .padding()
                
                Button(action: {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }, label: {
                    Image(systemName: "photo")
                })
                .padding()
                
                Spacer()
                
                Button(action: {
                    imageModel.getDogs()
                }) { () -> Text in
                    Text("Random")
                        .bold()
                }
            }
            .padding(.horizontal, 30)
            
        }
        .sheet(isPresented: self.$isImagePickerDisplay, onDismiss: {
            if selectedImage != nil {
                imageModel.updateDog(image: selectedImage!.pngData())
            }
        }) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        
    }
    
}
