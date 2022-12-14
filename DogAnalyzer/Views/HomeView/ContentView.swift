//
//  ContentView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case showDetailView,
         showOptionMenu,
         isImagePickerDisplay,
         showDogShuffleView
    
    var id: String {
        "hash"
    }
}

struct ContentView: View {
    @EnvironmentObject var model: ContentModel
    
    @State private var sourceType: UIImagePickerController.SourceType?
    @State private var selectedImage: UIImage?
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0.0) {
            GeometryReader { geometry in
                
                // Title
                HStack(alignment: .center) {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .font(.title)
                        .frame(width: geometry.size.width - 40, height: geometry.size.height/12)
                    Spacer()
                    
                }
                
                MainImage(activeSheet: $activeSheet, geometry: geometry)
                
                
                Buttons(activeSheet: $activeSheet, sourceType: $sourceType, geometry: geometry)
                
            }
        }
        .modifier(TextColorStyle())
        .modifier(BackgroundColorStyle())
        .sheet(item: $activeSheet, onDismiss: {
            model.setLoadingFalse()
        }, content: { item in
            switch item {
            case .showDetailView:
                DogDetailView()
            case .showOptionMenu:
                SettingsMainMenu()
            case .isImagePickerDisplay:
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.$sourceType)
                    .onDisappear {
                        if selectedImage != nil {
                            self.model.newCameraImage(image: selectedImage!.pngData())
                        }
                    }
            case .showDogShuffleView:
                DogShuffleView()

            }
        })
        
    }
}
