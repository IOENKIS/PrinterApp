//
//  DocumentListView.swift
//  PrinterApp
//
//  Created by IVANKIS on 30.06.2024.
//

import SwiftUI

struct DocumentListView: View {
    let documents: FetchedResults<Document>
    var onSelectDocument: (Document) -> Void
    
    var body: some View {
        List {
            ForEach(documents, id: \.self) { document in
                DocumentRow(document: document)
                    .onTapGesture {
                        onSelectDocument(document)
                    }
            }
        }
    }
}
