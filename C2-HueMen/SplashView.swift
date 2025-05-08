//
//  SplashView.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 09/05/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var hasCompletedSetup = UserDefaults.standard.bool(forKey: "hasCompletedSetup")

    var body: some View {
        if isActive {
            if hasCompletedSetup {
                HomeScreen()
            } else {
                OnboardingView(onSetupComplete: {
                    hasCompletedSetup = true
                })
            }
        } else {
            VStack {
                Spacer()

                Image(.hueMenIcon) // Ganti dengan logo asli jika ada
                    .resizable()
                    .scaledToFit()
                    .frame(width: 187, height: 187)
                    .foregroundColor(.black)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .onAppear {
                // Simulasi splash delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashScreen()
}
