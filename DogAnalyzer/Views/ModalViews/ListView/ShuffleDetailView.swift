//
//  DogShuffleView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/3/22.
//

import SwiftUI

struct DogShuffleView: View {
    @EnvironmentObject var model: ContentModel
    
    @State private var showingAlert = false
    @State private var showImagePopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                ZStack {
                    Color.yellow.opacity(0.75)
                    
                    Picker("Color Scheme", selection: $model.selectedBreed) {
                        ForEach(typeOfBreeds, id: \.self) { breed in
                            Text(breed.dogCEOBreed.capitalized).tag(breed.dogCEOBreed)
                        }
                    }
                    .onChange(of: model.selectedBreed, perform:  { _ in
                        self.model.selectNewBreedPicker(newBreed: model.selectedBreed)
                    })
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height/15, alignment: .center)
                
                ScrollView {
                    
                    VStack(alignment: .leading) {
                            
                            Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(height: geometry.size.height/3, alignment: .top)
                                .clipped()
                            
                            Description(showingAlert: $showingAlert)
                            
                            SimilarWebImages(showImagePopUp: showImagePopUp, geometry: geometry)
                        
                    }
                    
                    .modifier(TextColorStyle())
                    .modifier(BackgroundColorStyle())
                }
            }
            
            
        }
    }
}
