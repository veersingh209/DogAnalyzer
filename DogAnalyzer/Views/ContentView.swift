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
    
    var body: some View {
        
        VStack {
            
            Text("Dog Breed Identification")
                .font(.title)
                .bold()
                .padding(.leading, 10)
            
            GeometryReader { geo in
                
                TabView() {
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                        
                        //                        if selectedImage != nil {
                        //                            Image(uiImage: selectedImage!)
                        //                                .resizable()
                        //                                .scaledToFill()
                        //                                .clipped()
                        //                        } else {
                        Image(uiImage: UIImage(data: imageModel.dog.imageData ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .clipped()
                        //                        }
                        //
                    }
                    .frame(
                        width: geo.size.width - 30,
                        height: geo.size.height,
                        alignment: .center
                    )
                    .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    .cornerRadius(15)
                    
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .shadow(
                    color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.65),
                    radius: 10,
                    x: -5,
                    y: 5
                )
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(imageModel.dog.results) { result in
                        DogRowView(imageLabel: result.imageLabel, confidence: result.confidence)
                    }
                    .padding([.leading, .top , .trailing], 10)
                }
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
                DispatchQueue.main.async {
                    imageModel.updateDog(image: selectedImage!.pngData())
                }
            }
        }) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(imageModel: DogModel())
    }
}
