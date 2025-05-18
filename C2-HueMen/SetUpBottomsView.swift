//
//  SetUpBottomsView.swift
//  C2-HueMen
//
//  Created by Ahmad Kurniawan Ibrahim on 08/05/25.
//

import SwiftUI

struct SelectBottomColorsView: View {
    var onSetupComplete: (() -> Void)? = nil
    @StateObject private var colorManager = ColorClosetManager.shared
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
    @State private var alertMessage = ""
    @State private var showDuplicateAlert = false
    
    @State private var navigateToHome = false
    
    private func isDuplicateSolidColor(_ color: Color) -> Bool {
        let colors = solidBottomColors
        return colors.contains { existingColor in
            let components1 = UIColor(existingColor).cgColor.components ?? []
            let components2 = UIColor(color).cgColor.components ?? []
            return components1.count == components2.count &&
                   zip(components1, components2).allSatisfy { abs($0 - $1) < 0.01 }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 40)
                // Title
                Text("Select Colors of Bottoms You Have")
                    .foregroundStyle(.black)
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                // Subtitle
                Text("'Bottom' refers to clothing worn on the lower body such as pants, shorts, jeans, etc")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 1)
                    .padding(.horizontal, 18)
                // Solid Color Section
                SectionTitle(text: "Solid Color")
                    .padding(.top, 30)
                    .foregroundStyle(.black)
                ColorBlockGrid(
                    colors: solidBottomColors,
                    selectedColors: $selectedBottomColors,
                    onAddColor: {
                        showSolidColorPicker = true
                    }
                )
//                // Multi Color Section
//                SectionTitle(text: "Multi Color")
//                    .padding(.top, 35)
//                    .foregroundStyle(.black)
//                MultiColorBlockGrid(
//                    colors: multiBottomColors,
//                    selectedIndices: $selectedMultiBottomColors,
//                    onAddColor: {
//                        showMultiColorPicker = true
//                    }
//                )
                Spacer()
                
                NavigationLink(destination: HomeScreen(), isActive: $navigateToHome) {
                    EmptyView()
                }
                Button(action: {
                    // Save selected colors to ColorClosetManager
                    colorManager.updateFromSetup(
                        topSolidColors: colorManager.solidTopColors,
                        topMultiColors: colorManager.multiTopColors,
                        bottomSolidColors: Array(selectedBottomColors),
                        bottomMultiColors: selectedMultiBottomColors.map { multiBottomColors[$0] }
                    )
                    UserDefaults.standard.set(true, forKey: "hasCompletedSetup")
                    onSetupComplete?()
                    navigateToHome = true
                }) {
                    Text("Save")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 15)
                        .padding()
                        .background((selectedBottomColors.isEmpty && selectedMultiBottomColors.isEmpty) ? Color.gray.opacity(0.3) : Color.black)
                        .cornerRadius(10)
                }
                .disabled(selectedBottomColors.isEmpty && selectedMultiBottomColors.isEmpty)
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showSolidColorPicker) {
                SolidColorPickerSheet(newColor: $newBottomColor) {
                    if isDuplicateSolidColor(newBottomColor) {
                        alertMessage = "This color already exists in the solid color option"
                        showDuplicateAlert = true
                    } else {
                        solidBottomColors.append(newBottomColor)
                    }
                        showSolidColorPicker = false
                }
            }
            .alert("Duplicate Color", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct SelectBottomColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectBottomColorsView()
    }
}

