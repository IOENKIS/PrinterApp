//
//  SettingsView.swift
//  PrinterApp
//
//  Created by IVANKIS on 26.06.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        NavigationLink(destination: Text("Update Plan View")) {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("Update your plan")
                            }
                        }
                        .padding(.vertical, 8)
                        .cornerRadius(10)
                    }
                    .background {
                        Image("gradientUpdatePlan")
                    }

                    Section {
                        NavigationLink(destination: Text("Restore Purchase View")) {
                            Text("Restore purchase")
                        }
                        NavigationLink(destination: Text("Feedback View")) {
                            Text("Feedback")
                        }
                        NavigationLink(destination: Text("Share Application View")) {
                            Text("Share application")
                        }
                        NavigationLink(destination: Text("Help Center View")) {
                            Text("Help center")
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.white)

                    Section {
                        HStack {
                            Button(action: {
                                // Handle Privacy Policy action
                            }) {
                                Text("Privacy Policy")
                            }
                            Spacer()
                            Button(action: {
                                // Handle Terms & Conditions action
                            }) {
                                Text("Terms & Conditions")
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
