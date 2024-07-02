//
//  PrinterListView.swift
//  PrinterApp
//
//  Created by IVANKIS on 02.07.2024.
//

import SwiftUI

struct Printer: Identifiable {
    var id = UUID()
    var name: String
    var ipAddress: String
}

struct PrinterListView: View {
    @State private var printers: [Printer] = [
        Printer(name: "HP LaserJet P1102w", ipAddress: "192.168.2.56"),
        Printer(name: "HP LaserJet P1102w", ipAddress: "192.168.2.57"),
        Printer(name: "HP LaserJet P1102w", ipAddress: "192.168.2.58"),
        Printer(name: "HP LaserJet P1102w", ipAddress: "192.168.2.59")
    ]
    @State private var selectedPrinterID: UUID?

    var body: some View {
        List(printers) { printer in
            HStack {
                Image(systemName: "printer.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(printer.name)
                        .font(.headline)
                    Text(printer.ipAddress)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                if selectedPrinterID == printer.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 8)
            .onTapGesture {
                selectedPrinterID = printer.id
            }
        }
        .navigationTitle("Wi-Fi Printers")
    }
}

struct PrinterListView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterListView()
    }
}
