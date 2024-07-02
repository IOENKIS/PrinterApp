//
//  MainView.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct MainView: View {
    @State private var selector: Bool = true
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        TabView{
            ScansView()
                .tabItem {
                    selector ? Image("tabScanIcon") : Image("selectedTabScanIcon")
                }
                .onAppear {
                    selector = false
                }
            SettingsView()
                .tabItem {
                    !selector ? Image("tabSettingsIcon") : Image("selectedTabSettingsIcon")
                }
                .onAppear {
                    selector = true
                }
        }
        .environment(\.managedObjectContext, viewContext)
    }
}

#Preview {
    MainView()
}
