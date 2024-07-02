//
//  DetailView.swift
//  PrinterApp
//
//  Created by IVANKIS on 02.07.2024.
//

import SwiftUI
import CoreData
import PDFKit

enum ItemsType: String {
    case jpg = "jpg"
    case pdf = "pdf"
}

struct DetailView: View {
    @ObservedObject var document: Document
    var onShare: () -> Void
    var onRename: () -> Void
    var onPrint: () -> Void
    var onDelete: () -> Void
    var onDismiss: () -> Void

    @State private var showRenameAlert = false
    @State private var newName = ""
    @State private var showShareSheet = false
    @State private var shareItems: [Any] = []

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 20) {
                HStack {
                    if let imageData = document.imageData, let image = UIImage(data: imageData), document.pageCount == 1 {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 85, height: 110)
                            .cornerRadius(8)
                    } else if let imageData = document.imageData, document.pageCount > 1 {
                        PDFKitView(data: imageData)
                            .frame(width: 85, height: 110)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(document.name ?? "Unknown Document")
                            .font(.headline)
                        Text("\(document.pageCount) pages • \(formattedDate(document.date))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Divider()
                
                VStack(spacing: 15) {
                    Button(action: {
                        prepareShareSheet()
                        showShareSheet = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                            Spacer()
                        }
                    }
                    .padding()
                    .sheet(isPresented: $showShareSheet, content: {
                        ActivityView(activityItems: shareItems)
                    })
                    
                    Button(action: {
                        newName = document.name ?? ""
                        showRenameAlert = true
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Rename")
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Button(action: onPrint) {
                        HStack {
                            Image(systemName: "printer")
                            Text("Print")
                            Spacer()
                        }
                    }
                    .padding()
                    
                    Button(action: onDelete) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                            Spacer()
                        }
                        .foregroundColor(.red)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
        }
        .alert("Rename Document", isPresented: $showRenameAlert) {
            TextField("New name", text: $newName)
            Button("Cancel", role: .cancel) {}
            Button("Rename") {
                renameDocument(newName)
                onRename()
            }
        } message: {
            Text("Enter a new name for the document")
        }
    }

    private func prepareShareSheet() {
        if let imageData = document.imageData {
            if document.pageCount == 1, let image = UIImage(data: imageData) {
                shareItems = [image]
            } else {
                shareItems = [imageData]
            }
        }
    }

    private func renameDocument(_ newName: String) {
        document.name = newName
        do {
            try document.managedObjectContext?.save()
        } catch {
            print("Failed to rename document: \(error)")
        }
    }
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func printDocument() {
            guard let imageData = document.imageData else {
                print("No document data available.")
                return
            }

            var data: [Data] = [imageData]
            var fileType: ItemsType = .jpg

            if document.pageCount > 1 {
                fileType = .pdf
            }

            printFile(data: data, fileType: fileType)
        }

        private func printFile(data: [Data], fileType: ItemsType) {
            guard UIPrintInteractionController.isPrintingAvailable else {
                print("Printing is not available.")
                return
            }
            
            let printController = UIPrintInteractionController.shared
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.outputType = .general
            printInfo.jobName = "Print Job"
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = true
            
            switch fileType {
            case .pdf:
                printController.printingItem = data.first
            case .jpg:
                printController.printingItems = data
            }
            
            printController.present(animated: true, completionHandler: nil)
        }
}

struct PDFKitView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(data: data)
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
