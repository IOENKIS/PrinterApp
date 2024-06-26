//
//  MainView.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

enum Tab {
    case scan, settings
}

struct MainView: View {
    @State private var selector: Bool = true
    var body: some View {
        TabView{
            ScansView()
                .tabItem {
                    selector ? Image("tabScanIcon") : Image("selectedTabScanIcon")
                }
                .tag(Tab.scan)
                .onAppear {
                    selector = false
                }
            SettingsView()
                .tabItem {
                    !selector ? Image("tabSettingsIcon") : Image("selectedTabSettingsIcon")
                }
                .tag(Tab.scan)
                .onAppear {
                    selector = true
                }
        }
    }
}

#Preview {
    MainView()
}
