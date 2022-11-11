//
//  HomeTutorialView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI
import PopupView

struct HomeTutorialView: View {
    @Binding var currentStep: CurrentStep
    
    @State var showImagePopUp = true
    @State var showCameraPopUp = false
    @State var showPhotoPopUp = false
    @State var showRandomImagePopUp = false
    @State var showSettingsPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                if showImagePopUp {
                    Image("tutorialMain")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else if showCameraPopUp {
                    Image("tutorialCamera")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else if showPhotoPopUp {
                    Image("tutorialPhoto")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else if showRandomImagePopUp {
                    Image("tutorialShuffle")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Image("tutorialSettings")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
                
            }
            .popup(isPresented: $showImagePopUp, type: .floater(verticalPadding: 50, useSafeAreaInset: false), position: .bottom, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showCameraPopUp = true
            }, view: {
                TutorialPopUps(text: "All pictures will be displayed here", currentStep: 1, height: 100, width: 300)
            })
            .popup(isPresented: $showCameraPopUp, type: .floater(verticalPadding: 500, useSafeAreaInset: false), position: .top, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showPhotoPopUp = true
            }, view: {
                TutorialPopUps(text: "To take a picture of your dog click here", currentStep: 2, height: 300, width: 300)
            })
            .popup(isPresented: $showPhotoPopUp, type: .floater(verticalPadding: 520, useSafeAreaInset: false), position: .top, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showRandomImagePopUp = true
            }, view: {
                TutorialPopUps(text: "To upload a existing dog pictures from your camera roll click here", currentStep: 3, height: 300, width: 300)
            })
            .popup(isPresented: $showRandomImagePopUp, type: .floater(verticalPadding: 520, useSafeAreaInset: false), position: .top, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showSettingsPopUp = true
            }, view: {
                TutorialPopUps(text: "To display random dog breed click here", currentStep: 4, height: 100, width: 300)
            })
            .popup(isPresented: $showSettingsPopUp, type: .floater(verticalPadding: 150, useSafeAreaInset: false), position: .bottom, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                currentStep = .detailTutorial
            }, view: {
                TutorialPopUps(text: "To access the app's settings click here", currentStep: 5, height: 100, width: 300)
            })
        }
    }
}

struct HomeTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTutorialView(currentStep: .constant(.homeTutorial))
    }
}
