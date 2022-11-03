//
//  WelcomeView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var currentStep: CurrentStep
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Text("Scan pictures of your dog")
                .font(.title3)
                .padding(.top, 8)
            
            Text("Use our advanced AI to detect your dogs breed")
                .font(.title3)
                .padding(.top, 8)
            
            Text("View images of various dog breeds")
                .font(.title3)
                .padding(.top, 8)
            
            
            Spacer()
            Spacer()

            Button {
                currentStep = .homeTutorial
            } label: {
                Text("Get Started")
                    .font(.title3)
            }
            .buttonStyle(OnboardingCustomButton())
            
            
            Text("By tapping ‘Continue’, you agree to our Privacy Policy.")
                .font(.caption)
                .padding(.top, 14)
                .padding(.bottom, 61)
        }
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
        .padding()
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(currentStep: .constant(.welcome))
    }
}
