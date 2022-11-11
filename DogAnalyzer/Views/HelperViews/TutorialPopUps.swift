//
//  TutorialPopUps.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct TutorialPopUps: View {
    let text: String
    let currentStep: Int
    let height: CGFloat?
    let width: CGFloat?
    
    var body: some View {
        VStack {
            Text(text)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding([.top, .horizontal])
                .foregroundColor(.black)
            
            HStack {
                Text("\(currentStep)/9")
                    .foregroundColor(.black)
                
                Spacer()
                
                Button {
                    //
                } label: {
                    if currentStep == 9 {
                        Text("Close")
                    } else {
                        Text("Next")
                    }
                }
            }
            .padding([.bottom, .top, .horizontal])

        }
        .background(Color.yellow)
        .cornerRadius(10)
        .frame(width: width, height: height)

    }
}

struct TutorialPopUps_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPopUps(
            text: "Text will go here",
            currentStep: 1,
            height: 100,
            width: 200)
    }
}
