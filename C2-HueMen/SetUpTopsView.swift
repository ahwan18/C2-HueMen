import SwiftUI

struct SelectTopColorsView: View {
    var onSetupComplete: (() -> Void)? = nil
    @StateObject private var colorManager = ColorClosetManager.shared
    @State private var solidColors: [Color] = [
        .white, .black, .gray, .brown, .uGreen, Color(red: 0.0, green: 0.2, blue: 0.4), // navy
        Color(red: 0.7, green: 0.85, blue: 1.0), // light blue
        .uYellow, .uRed, .uPink
    ]
    @State private var multiColors: [(Color, Color)] = [
        (.white, .blue),
        (.gray, .black),
        (.blue, Color(red: 0.7, green: 0.85, blue: 1.0)), // blue & light blue
        (.white, .gray)
    ]
    @State private var selectedColors: Set<Color> = []
    @State private var selectedMultiColors: Set<Int> = []
    @State private var showSolidColorPicker = false
    @State private var showMultiColorPicker = false
    @State private var newColor: Color = .black
    @State private var newMultiColor1: Color = .gray
    @State private var newMultiColor2: Color = .blue
    @State private var showActualColorPicker = false
    @State private var colorPickerTarget: ColorPickerTarget = .solid
    @State private var navigateToBottoms = false
    @State private var alertMessage = ""
    @State private var showDuplicateAlert = false

    enum ColorPickerTarget {
        case solid
        case multiLeft
        case multiRight
    }
    
    // Add function to check for duplicate colors
    private func isDuplicateSolidColor(_ color: Color) -> Bool {
        let colors = solidColors
        return colors.contains { existingColor in
            let components1 = UIColor(existingColor).cgColor.components ?? []
            let components2 = UIColor(color).cgColor.components ?? []
            return components1.count == components2.count &&
                   zip(components1, components2).allSatisfy { abs($0 - $1) < 0.01 }
        }
    }
    
    private func isDuplicateMultiColor(_ colors: (Color, Color)) -> Bool {
        let multiColors = multiColors
        return multiColors.contains { existingPair in
            let components1_1 = UIColor(existingPair.0).cgColor.components ?? []
            let components1_2 = UIColor(existingPair.1).cgColor.components ?? []
            let components2_1 = UIColor(colors.0).cgColor.components ?? []
            let components2_2 = UIColor(colors.1).cgColor.components ?? []
            
            let firstColorMatch = components1_1.count == components2_1.count &&
                                zip(components1_1, components2_1).allSatisfy { abs($0 - $1) < 0.01 }
            let secondColorMatch = components1_2.count == components2_2.count &&
                                 zip(components1_2, components2_2).allSatisfy { abs($0 - $1) < 0.01 }
            
            return firstColorMatch && secondColorMatch
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 40)
                
                // Title
                Text("Select Colors of Tops You Have")
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                
                // Subtitle
                Text("'Top' refers to clothing worn on the upper body such as shirt, T-shirt, jacket, etc")
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
                    colors: solidColors,
                    selectedColors: $selectedColors,
                    onAddColor: {
                        showSolidColorPicker = true
                    }
                )
             
                // Multi Color Section
                SectionTitle(text: "Multi Color")
                    .padding(.top, 35)
                    .foregroundStyle(.black)
                MultiColorBlockGrid(
                    colors: multiColors,
                    selectedIndices: $selectedMultiColors,
                    onAddColor: {
                        showMultiColorPicker = true
                    }
                )
                
                Spacer()
                
                NavigationLink(destination: SelectBottomColorsView(onSetupComplete: onSetupComplete), isActive: $navigateToBottoms) {
                    EmptyView()
                }
                
                Button(action: {
                    // Save selected colors to ColorClosetManager
                    colorManager.updateFromSetup(
                        topSolidColors: Array(selectedColors),
                        topMultiColors: selectedMultiColors.map { multiColors[$0] },
                        bottomSolidColors: colorManager.solidBottomColors,
                        bottomMultiColors: colorManager.multiBottomColors
                    )
                    navigateToBottoms = true
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 15)
                        .padding()
                        .background((selectedColors.isEmpty && selectedMultiColors.isEmpty) ? Color.gray.opacity(0.3) : Color.black)
                        .cornerRadius(10)
                }
                .disabled(selectedColors.isEmpty && selectedMultiColors.isEmpty)
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea())
            .sheet(isPresented: $showSolidColorPicker) {
                SolidColorPickerSheet(newColor: $newColor) {
                    if isDuplicateSolidColor(newColor) {
                        alertMessage = "This color already exists in the solid color option"
                        showDuplicateAlert = true
                    } else {
                        solidColors.append(newColor)
                    }
                        showSolidColorPicker = false
                }
            }
            .sheet(isPresented: $showMultiColorPicker) {
                MultiColorPickerSheet(newLeftColor: $newMultiColor1, newRightColor: $newMultiColor2) {
                    if isDuplicateMultiColor((newMultiColor1, newMultiColor2)) {
                        alertMessage = "This color combination already exists in the multi color option"
                        showDuplicateAlert = true
                    } else {
                        multiColors.append((newMultiColor1, newMultiColor2))
                    }
                    showMultiColorPicker = false
                }
            }
            .alert("Duplicate Color", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Reusable Components

struct SectionTitle: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 24)
            Spacer()
        }
    }
}

struct ColorBlockGrid: View {
    let colors: [Color]
    @Binding var selectedColors: Set<Color>
    let columns = 4
    var onAddColor: (() -> Void)? = nil

    var body: some View {
        let total = colors.count + (onAddColor != nil ? 1 : 0)
        let items: [AnyView] = (0..<total).map { index in
            if index < colors.count {
                let color = colors[index]
                return AnyView(
                    ColorBlock(
                        color: color,
                        isSelected: selectedColors.contains(color)
                    )
                    .onTapGesture {
                        if selectedColors.contains(color) {
                            selectedColors.remove(color)
                        } else {
                            selectedColors.insert(color)
                        }
                    }
                )
            } else if index == colors.count, let onAddColor = onAddColor {
                return AnyView(AddColorBlock(action: onAddColor))
            } else {
                return AnyView(Spacer())
            }
        }
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: columns)
        LazyVGrid(columns: gridItems, spacing: 15) {
            ForEach(0..<items.count, id: \.self) { index in
                items[index]
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
        .padding(.bottom, 25)
    }
}

struct ColorBlock: View {
    let color: Color
    let isSelected: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: 75, height: 55)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.blue))
                    .offset(x: 30, y: -20)
            }
        }
    }
}

struct AddColorBlock: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(.lightGrayPlusButton)
                    .frame(width: 75, height: 55)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.5))
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
            }
        }
    }
}

struct MultiColorBlockGrid: View {
    let colors: [(Color, Color)]
    @Binding var selectedIndices: Set<Int>
    let columns = 4
    var onAddColor: (() -> Void)? = nil
    
    var body: some View {
        let total = colors.count + (onAddColor != nil ? 1 : 0)
        let items: [AnyView] = (0..<total).map { index in
            if index < colors.count {
                let colorPair = colors[index]
                return AnyView(
                    MultiColorBlock(
                        leftColor: colorPair.0,
                        rightColor: colorPair.1,
                        isSelected: selectedIndices.contains(index)
                    )
                    .onTapGesture {
                        if selectedIndices.contains(index) {
                            selectedIndices.remove(index)
                        } else {
                            selectedIndices.insert(index)
                        }
                    }
                )
            } else if index == colors.count, let onAddColor = onAddColor {
                return AnyView(AddColorBlock(action: onAddColor))
            } else {
                return AnyView(Spacer())
            }
        }
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 10), count: columns)
        LazyVGrid(columns: gridItems, spacing: 15) {
            ForEach(0..<items.count, id: \.self) { index in
                items[index]
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
    }
}

struct MultiColorBlock: View {
    let leftColor: Color
    let rightColor: Color
    let isSelected: Bool

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(leftColor)
                Rectangle()
                    .fill(rightColor)
            }
            .frame(width: 75, height: 55)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.blue))
                    .offset(x: 30, y: -20)
            }
        }
    }
}

struct SolidColorPickerSheet: View {
    @Binding var newColor: Color
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.bottom, 8)

            Text("Add New Solid Color")
                .font(.headline)
                .padding(.bottom, 15)

            ColorPicker("", selection: $newColor, supportsOpacity: false)
                .labelsHidden()
                .scaleEffect(1.5)
                .padding(.horizontal, 32)
                .padding(.bottom, 15)
            
            Button(action: onAdd ) {
                Text("Add Color")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }
        }
        .presentationDetents([.height(220)])
    }
}

struct MultiColorPickerSheet: View {
    @Binding var newLeftColor: Color
    @Binding var newRightColor: Color
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Add New Multi Color")
                .font(.headline)

            VStack(spacing: 12) {
                HStack {
                    Text("Color 1")
                    ColorPicker("", selection: $newLeftColor, supportsOpacity: false)
                        .labelsHidden()
                }
                HStack {
                    Text("Color 2")
                    ColorPicker("", selection: $newRightColor, supportsOpacity: false)
                        .labelsHidden()
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)

            Button("Add Color", action: onAdd)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .presentationDetents([.height(250)])
    }
}


// MARK: - Preview

struct SelectTopColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTopColorsView()
    }
}
