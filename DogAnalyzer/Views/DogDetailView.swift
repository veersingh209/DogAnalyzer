//
//  DogDetailView.swift
//  DogAnalyzer
//
//  Created by Veer Singh on 10/26/22.
//
import SwiftUI

struct DogDetailView: View {
    @EnvironmentObject var model: ContentModel
    @State private var showingAlert = false
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading) {
                VStack(alignment: .center) {
                    Image(uiImage: UIImage(data: model.imageData ?? Data()) ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250, alignment: .top)
                        .clipped()
                }
                
                VStack(alignment: .leading, spacing: 1.0) {
                    
                    Text(model.identifier ?? titleErrorMessage)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text("\(model.dogInfo ?? wikiErrorMessage)")
                        .font(.caption)
                    
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
                        }
                        .alert("Unable to open link", isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                        // Disbale button if no assioated Wiki result
                        .disabled(model.dogInfo == nil)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                    }
                    
                    
                }
                .padding()
                
                Divider()
            }
            
        }
    }
}
