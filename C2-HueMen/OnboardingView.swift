//
//  OnboardingView.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 09/05/25.
//

import SwiftUI

struct OnboardingView: View {
    var onSetupComplete: (() -> Void)? = nil
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                Image(.wardrobeOnboarding)
                    .resizable()
                    .frame(width: 300, height: 314)
                    .padding(.bottom, 44)
                
                
                VStack(spacing: 10) {
                    Text("Match Your Outfit's Colors")
                        .font(.system(size: 42))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                    
                    
                    Text("Start by adding the color of the tops and bottoms you already own.")
                        .font(.body)
                        .foregroundStyle(.description)
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                }
                .padding(.bottom, 16)
                
                Spacer()
                
                NavigationLink(destination: SelectTopColorsView(onSetupComplete: onSetupComplete)) {
                    Text("Start")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: 187.5, maxHeight: 15)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnboardingView()
}
