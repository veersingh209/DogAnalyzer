//
//  StartView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var model: ContentModel

    var body: some View {
        VStack {
            ContentView()
        }
        // Onboarding sequence
        .fullScreenCover(isPresented: $model.isOnboarding) {
        } content: {
            OnBoardingContainerView()
        }

    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
