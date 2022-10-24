//
//  ContentView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var imageModel: DogModel
    
    var body: some View {
        VStack {
            Text("Dog Breed Ideniftication")
                .font(.title)
                .bold()
                .padding(.leading, 10)
            
            GeometryReader { geo in
                
                TabView() {
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                        
                        Image(uiImage: UIImage(data: imageModel.dog.imageData ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .clipped()
                        
                    }
                    .frame(
                        width: geo.size.width - 30,
                        height: geo.size.height,
                        alignment: .center
                    )
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
            
            Button(action: {
                imageModel.getDogs()
            }) { () -> Text in
                Text("Next")
                    .bold()
            }
        }

    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(imageModel: DogModel())
    }
}
