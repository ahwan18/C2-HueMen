//
//  SetUpBottomsView.swift
//  C2-HueMen
//
//  Created by Ahmad Kurniawan Ibrahim on 08/05/25.
//

import SwiftUI

struct SelectBottomColorsView: View {
    @State private var solidBottomColors: [Color] = [
        .white, .black, .gray, Color(red: 0.0, green: 0.2, blue: 0.4), // navy
        Color(red: 0.7, green: 0.85, blue: 1.0), // light blue
        .brown
    ]
    @State private var multiBottomColors: [(Color, Color)] = [
        (.white, .blue),
        (.gray, .black),
        (.blue, Color(red: 0.7, green: 0.85, blue: 1.0)), // blue & light blue
        (.white, .gray)
    ]
    @State private var selectedBottomColors: Set<Color> = []
    @State private var selectedMultiBottomColors: Set<Int> = []
    @State private var showSolidColorPicker = false
    @State private var showMultiColorPicker = false
    @State private var newBottomColor: Color = .black
    @State private var newMultiBottomColor1: Color = .gray
    @State private var newMultiBottomColor2: Color = .blue

    var body: some View {
        VStack {
            Spacer().frame(height: 40)
            // Title
            Text("Select Colors of Bottoms You Have")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
            // Subtitle
            Text("'Bottom' refers to clothing worn on the lower body such as pants, skirt, shorts, etc")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 1)
                .padding(.horizontal, 18)
            // Solid Color Section
            SectionTitle(text: "Solid Color")
                .padding(.top, 30)
            ColorBlockGrid(
                colors: solidBottomColors,
                selectedColors: $selectedBottomColors,
                onAddColor: {
                    showSolidColorPicker = true
                }
            )
            // Multi Color Section
            SectionTitle(text: "Multi Color")
                .padding(.top, 35)
            MultiColorBlockGrid(
                colors: multiBottomColors,
                selectedIndices: $selectedMultiBottomColors,
                onAddColor: {
                    showMultiColorPicker = true
                }
            )
            Spacer()
            Button(action: {
                // Action for continue
            }) {
                Text("Save")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSolidColorPicker) {
            SolidColorPickerSheet(newColor: $newBottomColor) {
                solidBottomColors.append(newBottomColor)
                showSolidColorPicker = false
            }
        }
        .sheet(isPresented: $showMultiColorPicker) {
            MultiColorPickerSheet(
                newLeftColor: $newMultiBottomColor1,
                newRightColor: $newMultiBottomColor2
            ) {
                multiBottomColors.append((newMultiBottomColor1, newMultiBottomColor2))
                showMultiColorPicker = false
            }
        }
    }
}

struct SelectBottomColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBottomColorsView()
    }
}

