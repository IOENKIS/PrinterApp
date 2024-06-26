//
//  Document.swift
//  PrinterApp
//
//  Created by IVANKIS on 26.06.2024.
//

import Foundation
import CoreData

@objc(Document)
public class Document: NSManagedObject {
    @NSManaged public var title: String
    @NSManaged public var pages: Int16
    @NSManaged public var date: Date
    @NSManaged public var image: Data
}

extension Document {
    static func fetchAllDocuments() -> NSFetchRequest<Document> {
        let request: NSFetchRequest<Document> = Document.fetchRequest() as! NSFetchRequest<Document>
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return request
    }
}
