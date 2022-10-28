//
//  ListCellColorStyle.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/28/22.
//

import SwiftUI

struct ListCellColorStyle: ViewModifier {
    
    @EnvironmentObject var model: ContentModel
    
    func body(content: Content) -> some View {
        switch model.colorSelection {
        case .system:
            return content
                .listRowBackground(Color("AdaptiveListColor"))
        case .dark:
            return content
                .listRowBackground(Color("systemListColorDark"))
        case .light:
            return content
                .listRowBackground(Color.white)
        case .none:
            return content
                .listRowBackground(Color("AdaptiveListColor"))
        }
    }
}
