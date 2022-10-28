//
//  TextColorStyle.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/28/22.
//

import SwiftUI

struct TextColorStyle: ViewModifier {
    @EnvironmentObject var model: ContentModel
    
    func body(content: Content) -> some View {
        switch model.colorSelection {
        case .system:
            return content
                .foregroundColor(Color("AdaptiveText"))
        case .dark:
            return content
                .foregroundColor(Color("systemTextColorDark"))
        case .light:
            return content
                .foregroundColor(Color("systemTextColorLight"))
        }
    }
    
}
