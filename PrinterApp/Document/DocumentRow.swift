//
//  DocumentRow.swift
//  PrinterApp
//
//  Created by IVANKIS on 30.06.2024.
//

import SwiftUI

struct DocumentRow: View {
    let document: Document

    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: document.image ?? Data()) ?? UIImage())
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(document.name ?? "Unknown Document")
                    .font(.headline)
                Text("\(formattedDate(document.date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "ellipsis")
        }
        .padding()
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
