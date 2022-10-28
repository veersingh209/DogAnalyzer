//
//  BackgroundColorStyle.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/28/22.
//

import SwiftUI

struct BackgroundColorStyle: ViewModifier {
    @EnvironmentObject var model: ContentModel
    
    func body(content: Content) -> some View {
        switch model.colorSelection {
        case .system:
            return content
                .background(Color("AdaptiveBackground"))
        case .dark:
            return content
                .background(Color.black)
        case .light:
            return content
                .background(Color("systemListBackgroundColorLight"))
        case .none:
            return content
                .background(Color("AdaptiveBackground"))
        }
    }
}
