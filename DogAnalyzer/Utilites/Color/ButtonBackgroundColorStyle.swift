//
//  ButtonBackgroundColorStyle.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct ButtonBackgroundColorStyle: ViewModifier {
    @EnvironmentObject var model: ContentModel
    
    func body(content: Content) -> some View {
        switch model.colorSelection {
        case .system:
            return content
                .foregroundColor(Color("AdaptiveBackground"))
        case .dark:
            return content
                .foregroundColor(Color("systemTextColorLight"))
        case .light:
            return content
                .foregroundColor(Color("systemListBackgroundColorLight"))
        }
    }
    
}
