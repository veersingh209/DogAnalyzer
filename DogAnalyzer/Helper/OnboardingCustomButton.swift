//
//  OnboardingCustomButton.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct OnboardingCustomButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            
            Rectangle()
                .frame(height: 50)
                .cornerRadius(6)
                .foregroundColor(Color.yellow)
            
            configuration.label
                .foregroundColor(Color.black)
            
        }
    }
    
}
