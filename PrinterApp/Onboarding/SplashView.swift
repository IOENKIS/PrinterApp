//
//  SplashView.swift
//  PrinterApp
//
//  Created by IVANKIS on 25.06.2024.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack(spacing: 40){
                Spacer()
                Spacer()
                Image("splashIcon")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Printer App")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundStyle(.black)
                Spacer()
                Spacer()
                Image("loadingCircle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    SplashView()
}
