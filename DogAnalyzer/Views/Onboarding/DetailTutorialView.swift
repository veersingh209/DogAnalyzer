//
//  DetailTutorialView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/2/22.
//

import SwiftUI

struct DetailTutorialView: View {
    @EnvironmentObject var model: ContentModel
    
    @State var showImagePopUp = true
    @State var showAIPopUp = false
    @State var showLinkPopUp = false
    @State var showPhotoPopUp = false
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                
                if showImagePopUp {
                    Image("tutorialMain")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else if showAIPopUp {
                    Image("tutorialAI")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else if showLinkPopUp {
                    Image("tutorialLink")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Image("tutorialMore")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                }
                
            }
            .popup(isPresented: $showImagePopUp, type: .floater(verticalPadding: 50, useSafeAreaInset: false), position: .bottom, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showAIPopUp = true
            }, view: {
                TutorialPopUps(text: "Click the main image to open up the detailed view", currentStep: 6, height: 100, width: 300)
            })
            .popup(isPresented: $showAIPopUp, type: .floater(verticalPadding: 250, useSafeAreaInset: false), position: .top, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showLinkPopUp = true
            }, view: {
                TutorialPopUps(text: "The AI's confidence level will be displayed here. \n The higher the number the more confident our AI is.", currentStep: 7, height: 100, width: 300)
            })
            .popup(isPresented: $showLinkPopUp, type: .floater(verticalPadding: 250, useSafeAreaInset: false), position: .bottom, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                showPhotoPopUp = true
            }, view: {
                TutorialPopUps(text: "To read more click the link icon. This will take you to the associated Wikipedia article", currentStep: 8, height: 300, width: 300)
            })
            .popup(isPresented: $showPhotoPopUp, type: .floater(verticalPadding: 400, useSafeAreaInset: false), position: .top, animation: .default, dragToDismiss: true, closeOnTap: true, closeOnTapOutside: false, backgroundColor: Color.yellow.opacity(0.2), dismissCallback: {
                model.onBoardCompleted(status: .onboardCompleted)
                UserDefaults.standard.set(UserOnboardStatus.onboardCompleted.rawValue, forKey: "isOnboarding")
            }, view: {
                TutorialPopUps(text: "Similar images will be displayed bellow. Scroll to see them all", currentStep: 9, height: 300, width: 300)
            })
        }
    }
}

struct DetailTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTutorialView()
    }
}
