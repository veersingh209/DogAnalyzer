//
//  DogDetailView.swift
//  DogAnalyzer
//\
//  Created by Veer Singh on 10/26/22.
//
import SwiftUI

struct DogDetailView: View {
    @EnvironmentObject var model: ContentModel
    
    @State private var showingAlert = false
    @State private var showImagePopUp = false
    
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
                    
                    SimilarWebImages(showImagePopUp: showImagePopUp, geometry: geometry)
                    
                }
                .modifier(TextColorStyle())
                .modifier(BackgroundColorStyle())
                
                
            }
            
        }
        .popup(isPresented: $showImagePopUp, type: .toast, position: .bottom, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
            showImagePopUp = false
        }, view: {
            TutorialPopUps(text: "Click the main image to open up the detailed view", currentStep: 6, height: 100, width: 300)
        })
    }
}
