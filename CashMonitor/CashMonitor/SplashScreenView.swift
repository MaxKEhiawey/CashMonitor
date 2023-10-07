//
//  SplashScreenView.swift
//  CashMonitor
//
//  Created by AMALITECH MACBOOK on 27/08/2023.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @State private var size = 0.8
    @State private var opacity = 0.5

        // Customise your SplashScreen here
    var body: some View {
        if !isActive {
            VStack {
                VStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 200.0, height: 200.0)
                        .cornerRadius(48)
                    Text("\(APPNAME)")
                        .font(Font.custom("Baskerville-Bold", size: 26))
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.00
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}
