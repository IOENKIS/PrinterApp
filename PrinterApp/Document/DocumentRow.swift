//
//  DocumentRow.swift
//  PrinterApp
//
//  Created by IVANKIS on 30.06.2024.
//

import SwiftUI
import PDFKit

struct DocumentRow: View {
    let document: Document
    

    var body: some View {
        HStack {
            if let imageData = document.imageData, let image = getImage(from: imageData, name: document.name) {
                Image(uiImage: image)
                    .resizable()
                    .frame(maxWidth: 130, maxHeight: 80)
                    .cornerRadius(8)
                    .padding(.trailing, 15)
            } else {
                Image(systemName: "doc")
                    .resizable()
                    .frame(maxWidth: 130, maxHeight: 80)
                    .cornerRadius(8)
                    .padding(.trailing, 15)
            }
            
            VStack(alignment: .leading) {
                Text(document.name ?? "Unknown Document")
                    .font(.headline)
                Text("\(formattedDate(document.date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if document.pageCount > 1 {
                     Text("\(document.pageCount) pages")
                         .font(.subheadline)
                         .foregroundColor(.gray)
                 }
            }
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.black)
            }
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func pdfThumbnail(data: Data) -> UIImage? {
        guard let document = PDFDocument(data: data), let page = document.page(at: 0) else {
            return nil
        }

        let pageBounds = page.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageBounds.size)
        return renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageBounds)
            ctx.cgContext.translateBy(x: 0.0, y: pageBounds.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            page.draw(with: .mediaBox, to: ctx.cgContext)
        }
    }
    
    private func getImage(from data: Data, name: String?) -> UIImage? {
        if let name = name, name.lowercased().hasSuffix(".pdf") {
            return pdfThumbnail(data: data)
        } else {
            return UIImage(data: data)
        }
    }
}
