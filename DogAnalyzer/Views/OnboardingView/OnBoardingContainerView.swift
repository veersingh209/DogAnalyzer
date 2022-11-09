//
//  OnBoardingContainerView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

enum CurrentStep: Int {
    case welcome = 0
    case homeTutorial = 1
    case detailTutorial = 2
}

struct OnBoardingContainerView: View {
    @State var currentStep: CurrentStep = .welcome
    
    var body: some View {
        
        ZStack {
            
            Color("systemListBackgroundColorLight")
                .edgesIgnoringSafeArea(.all)
            
            switch currentStep {
            case .welcome:
                WelcomeView(currentStep: $currentStep)
            case .homeTutorial:
                HomeTutorialView(currentStep: $currentStep)
            case .detailTutorial:
                DetailTutorialView()
            }
            
        }
        
    }
}

struct OnBoardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingContainerView()
    }
}
