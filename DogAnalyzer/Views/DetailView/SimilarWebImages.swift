//
//  SimilarWebImages.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct SimilarWebImages: View {
    @EnvironmentObject var model: ContentModel
    
    let geometry: GeometryProxy
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Divider()
                .frame(height: 3)
                .overlay(.yellow)
                .padding()
            
            Text("Similar Web Images")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(0..<model.similarResultsImageData.count, id: \.self) { imageIdx in
                    Image(uiImage: UIImage(data: model.similarResultsImageData[imageIdx] ?? Data()) ?? UIImage() )
                        .frame(width: geometry.size.width/2, height: geometry.size.height/5, alignment: .top)
                        .cornerRadius(10)
                }
            }
            
            Text("Images from Unsplash")
                .font(.caption)
                .padding()
        }
        
    }
}
