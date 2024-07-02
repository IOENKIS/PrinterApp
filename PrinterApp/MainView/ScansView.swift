//
//  ScansView.swift
//  PrinterApp
//
//  Created by IVANKIS on 26.06.2024.
//

import SwiftUI
import PDFKit
import VisionKit
import CoreData

struct ScansView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Document.date, ascending: false)]) var docs: FetchedResults<Document>
    @State private var showDocumentPicker = false
    @State private var showImagePicker = false
    @State private var showDocumentCamera = false
    @State private var showCropView = false
    @State private var scannedImage: UIImage?
    @State private var selectedDocument: Document?
    @State private var showDetailView = false
    @State private var refreshID = UUID()

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    if docs.isEmpty {
                        Image("emptyImage")
                            .padding(.bottom, 50)
                    } else {
                        DocumentListView(documents: docs) { document in
                            selectedDocument = document
                            showDetailView = true
                        }
                        .id(refreshID)
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
                                showDocumentCamera = true
                            }) {
                                Label("Scan Documents", systemImage: "doc.text.viewfinder")
                            }

                            Button(action: {
                                showImagePicker = true
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
                .navigationBarItems(trailing: NavigationLink(destination: PrinterListView()) {
                    Image(systemName: "printer")
                        .imageScale(.large)
                })
            }
            .zIndex(0)

            if showDetailView, let document = selectedDocument {
                DetailView(
                    document: document,
                    onShare: {
                        // Implement share action here
                    },
                    onRename: {
                        showDetailView = false
                        refreshID = UUID()
                    },
                    onPrint: {
                        // Implement print action here
                    },
                    onDelete: {
                        deleteDocument(document)
                        showDetailView = false
                    },
                    onDismiss: {
                        showDetailView = false
                    }
                )
                .zIndex(1)
                .transition(.opacity)
                .animation(.easeInOut, value: showDetailView)
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPickerView { url in
                importDocument(from: url)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView { image in
                scannedImage = image
                showCropView = true
            }
        }
        .sheet(isPresented: $showDocumentCamera) {
            DocumentCameraView { image in
                scannedImage = image
                showCropView = true
            }
        }
        .sheet(isPresented: $showCropView) {
            if let image = scannedImage {
                CropView(image: image) { croppedImage in
                    importImage(image: croppedImage)
                } onRetake: {
                    showCropView = false
                    showDocumentCamera = true
                }
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
        newDocument.name = "Scanned Document"
        newDocument.date = Date()
        newDocument.imageData = image.jpegData(compressionQuality: 1.0)
        newDocument.pageCount = 1

        do {
            try viewContext.save()
        } catch {
            print("Failed to save document: \(error)")
        }
    }

    private func deleteDocument(_ document: Document) {
        viewContext.delete(document)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete document: \(error)")
        }
    }
}
