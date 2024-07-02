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
    @StateObject private var browser = BonjourPrinterBrowser()
    @State private var selectedPrinterID: UUID?

    var body: some View {
        NavigationView {
            List(browser.printers) { printer in
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
            .onAppear {
                browser.startBrowsing()
            }
            .onDisappear {
                browser.stopBrowsing()
            }
        }
    }
}

struct PrinterListView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterListView()
    }
}
