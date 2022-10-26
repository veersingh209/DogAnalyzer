//
//  ImageDetailView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/26/22.
//
import SwiftUI

struct ImageDetailView: View {
    var model: DogModel
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Image(uiImage: UIImage(data: model.dog.imageData ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250, alignment: .center)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(model.dog.identifier)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                }
            }
            
        }
    }
}

struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(model: DogModel())
    }
}
