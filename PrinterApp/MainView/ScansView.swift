//
//  ScansView.swift
//  PrinterApp
//
//  Created by IVANKIS on 26.06.2024.
//

import SwiftUI
import PDFKit

struct ScansView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) var docs: FetchedResults<Document>
    @State private var showDocumentPicker = false
    var body: some View {
        NavigationStack {
            ZStack{
                if docs.isEmpty {
                    Image("emptyImage")
                        .padding(.bottom, 50)
                } else {
                    DocumentListView(documents: docs)
                }
                VStack {
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            showDocumentPicker = true
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
                            .padding(.leading, 200)
                            .padding(.bottom, 20)
                    }
                }
                .padding()
            }
            .navigationTitle("My Documents")
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPickerView { url in
                importDocument(from: url)
            }
        }
    }
    private func importDocument(from url: URL) {
        let newDocument = Document(context: viewContext)
        newDocument.name = url.lastPathComponent
        newDocument.date = Date()
        
        if let data = try? Data(contentsOf: url) {
            newDocument.imageData = data
            
            if url.pathExtension.lowercased() == "pdf" {
                if let pdfDocument = PDFDocument(data: data) {
                    newDocument.pageCount = Int16(pdfDocument.pageCount)
                }
            } else {
                newDocument.pageCount = 1
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save document: \(error)")
        }
    }
    
    private func importImage(image: UIImage) {
        let newDocument = Document(context: viewContext)
        newDocument.name = "Imported Photo"
        newDocument.date = Date()
        newDocument.imageData = image.jpegData(compressionQuality: 1.0)
        newDocument.pageCount = 1
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save document: \(error)")
        }
    }
}

#Preview {
    ScansView()
}


