//
//  test.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/4/22.
//

import SwiftUI

struct test: View {
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = "Red"

    var body: some View {
        VStack {
            ZStack {
                Color.yellow.opacity(0.75)
                
                HStack {
                    Spacer()
                    Picker("Please choose a color", selection: $selectedColor) {
                        ForEach(colors, id: \.self) {
                            Text($0)
                        }
                    }
                    Spacer()

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
