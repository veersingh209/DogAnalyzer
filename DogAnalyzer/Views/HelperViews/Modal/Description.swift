//
//  Description.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 11/1/22.
//

import SwiftUI

struct Description: View {
    @EnvironmentObject var model: ContentModel
    @Binding var showingAlert: Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 1.0) {
            
            // Title (Dog breed)
            // Hide if in list view
            if !model.shuffleMode {
                Text(model.identifier ?? titleErrorMessage)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
            }
            
            // AI confidence level
            // Hide if in list view
            if !model.shuffleMode {
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 0, y: 5)
                    
                    VStack {
                        HStack {
                            Text("AI Confidence Level")
                                .bold()
                                .foregroundColor(.black)
                            Spacer()
                            Text(String(format: "%.2f%%", (model.confidence ?? 0) * 100))
                                .bold()
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.top, 10)
                        
                        ProgressBar(value: model.confidence ?? 0)
                            .frame(height: 10)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                    }
                }
            }
            
            // Wiki info
            Text("\(model.dogInfo ?? wikiErrorMessage)")
                .font(.caption)
                .padding()
            
            // Link to wiki
            HStack {
                Spacer()
                Button {
                    let id = model.identifier!.replacingOccurrences(of: " ", with: "_")
                    
                    if let url = URL(string: "\(wikiURL)\(id)") {
                        UIApplication.shared.open(url)
                    } else {
                        showingAlert = true
                    }
                } label: {
                    Image(systemName: "link")
                        .foregroundColor(Color.blue)
                }
                .alert("Unable to open link", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                // Disable button if no associated Wiki result
                .disabled(model.identifier == nil)
                .padding(.top, 10)
                .padding(.trailing, 10)
            }
            
        }
        .padding()
        
    }
}

