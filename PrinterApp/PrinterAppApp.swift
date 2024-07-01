//
//  PrinterAppApp.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

@main
struct PrinterAppApp: App {
    @State private var dismissSplash = false
    @Environment(\.scenePhase) var scenePhase
    @State private var purchased: String?
    @StateObject private var dataController = PersistenceController()

    var body: some Scene {
        WindowGroup {
            ZStack {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dismissSplash.toggle()
                        }
                    }
                
                if dismissSplash {
                    if UserDefaults.standard.bool(forKey: "onboardingDone") == true {
                        MainView()
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                    } else {
                        OnboardingView()
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                    }
                }
            }
        }
    }
}
