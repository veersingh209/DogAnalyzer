//
//  DogAnalyzerApp.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/24/22.
//

import SwiftUI

@main
struct DogAnalyzerApp: App {
    
    var body: some Scene {
        WindowGroup {
            StartView()
                .environmentObject(ContentModel())
        }
    }
}
