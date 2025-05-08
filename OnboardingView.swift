//
//  OnboardingView.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 08/05/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(.wardrobeOnboarding)
                    .resizable()
                    .frame(width: 235.5, height: 235.5)
                    .padding(.bottom, 40)
                
                
                VStack(spacing: 10) {
                    Text("Match Your Outtfit's Colors")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                    
                    
                    Text("Start by adding the color of the tops and bottoms you already own.")
                        .font(.callout)
                        .foregroundStyle(.description)
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                }
                .padding(.bottom, 30)
                
                
                NavigationLink(destination: SelectTopColorsView()) {
                    Text("Start")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: 187.5, maxHeight: 12)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    OnboardingView()
}
