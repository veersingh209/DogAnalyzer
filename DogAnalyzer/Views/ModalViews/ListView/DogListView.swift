//
//  DogListView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/3/22.
//

import SwiftUI

struct DogListView: View {
    @EnvironmentObject var model: ContentModel
    @State private var showingAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    if model.loading {
                        ZStack {
                            Color("systemListBackgroundColorLight")
                                .edgesIgnoringSafeArea(.all)
                            
                            ProgressView()
                                .scaleEffect(2)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }

                    } else {
                        
                        Picker("Color Scheme", selection: $model.selectedBreed) {
                            ForEach(typeOfBreeds, id: \.self) { breed in
                                Text(breed).tag(breed)
                            }
                        }
                        .onChange(of: model.selectedBreed, perform:  { _ in
                            self.model.setNewBreed(selectedBreed: model.selectedBreed)
                        })
                        
                        
                        
                        
                        Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(height: geometry.size.height/3, alignment: .top)
                            .clipped()
                        
                        Description(showingAlert: $showingAlert)
                        
                        SimilarWebImages(geometry: geometry)
                    }
                    
                }
                .modifier(TextColorStyle())
                .modifier(BackgroundColorStyle())
            }
            
            
        }
    }
}
