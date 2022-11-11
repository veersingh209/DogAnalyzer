//
//  WebImageBottomSheet.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/10/22.
//

import SwiftUI

struct WebImageBottomSheet: View {
    @State var image: Data?
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                
                Rectangle()
                    .fill(Color.yellow)
                
                Image(uiImage: UIImage(data: image ?? Data()) ?? UIImage() )
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(35)
                    .frame(width: geo.size.width - 40, height: geo.size.height - 40)
                
            }
        }
    }
}
