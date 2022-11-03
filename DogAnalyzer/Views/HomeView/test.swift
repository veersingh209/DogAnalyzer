//
//  test.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/3/22.
//

import SwiftUI

struct test: View {
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView {
                
                VStack(alignment: .center) {
                    ZStack {
                        Color("systemListBackgroundColorLight")
                            .edgesIgnoringSafeArea(.all)
                        
                        ProgressView()
                            .scaleEffect(2)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.yellow))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                    
                }
            }
            
            
        }
        
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
