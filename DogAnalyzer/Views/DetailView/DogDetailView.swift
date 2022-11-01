//
//  DogDetailView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/26/22.
//
import SwiftUI

struct DogDetailView: View {
    @EnvironmentObject var model: ContentModel
    @State private var showingAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(height: geometry.size.height/3, alignment: .top)
                        .clipped()
                    
                    Description(showingAlert: $showingAlert)
                    
                    SimilarWebImages(geometry: geometry)
                    
                    
                }
                .modifier(TextColorStyle())
                .modifier(BackgroundColorStyle())
                
                
            }
            
        }
    }
}
