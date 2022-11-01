//
//  TempView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/31/22.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack {
                ZStack{
                    Circle()
                        .frame(width: geometry.size.width/5, height: geometry.size.height/5, alignment: .center)
                        .foregroundColor(.green)
                    Circle()
                        .frame(width: geometry.size.width/6, height: geometry.size.height/6, alignment: .center)
                    HStack {
                        Spacer()
                        Button(action: {
                            print("test")
                        }, label: {
                            Image(systemName: "camera")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        })
                        Spacer()
                    }
                    
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
        
        
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
