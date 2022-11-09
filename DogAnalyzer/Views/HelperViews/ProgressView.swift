//
//  ProgressView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/4/22.
//

import SwiftUI

struct ProgressViewCustom: View {
    let geometry: GeometryProxy
    var body: some View {
        ProgressView()
            .scaleEffect(2)
            .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
