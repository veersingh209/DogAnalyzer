//
//  DogRowView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

import SwiftUI

struct DogRowView: View {
    var imageLabel: String
    var confidence: Double
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
            VStack {
                HStack {
                    Text(imageLabel)
                        .bold()
                    Spacer()
                    Text(String(format: "%.2f%%", confidence * 100))
                        .bold()
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top, 10)
                
                ProgressBarView(value: confidence)
                    .frame(height: 10)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
            }
        }
    }
}

struct DogRowView_Previews: PreviewProvider {
    static var previews: some View {
        DogRowView(imageLabel: "Husky", confidence: 0.23)
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
