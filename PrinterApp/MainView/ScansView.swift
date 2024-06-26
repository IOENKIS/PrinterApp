//
//  ScansView.swift
//  PrinterApp
//
//  Created by IVANKIS on 26.06.2024.
//

import SwiftUI

struct ScansView: View {
    var body: some View {
        NavigationStack {
            ZStack{
                Image("emptyImage")
                    .padding(.bottom, 50)
                VStack {
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            // Дія для "Import Files"
                        }) {
                            Label("Import Files", systemImage: "square.and.arrow.down")
                        }
                        
                        Button(action: {
                            // Дія для "Scan Documents"
                        }) {
                            Label("Scan Documents", systemImage: "doc.text.viewfinder")
                        }
                        
                        Button(action: {
                            // Дія для "Choose Photos"
                        }) {
                            Label("Choose Photos", systemImage: "photo")
                        }
                    } label: {
                        Image("addIcon")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.leading, 250)
                            .padding(.bottom, 20)
                    }
                }
                .padding()
            }
            .navigationTitle("My Documents")
        }
    }
}

#Preview {
    ScansView()
}
