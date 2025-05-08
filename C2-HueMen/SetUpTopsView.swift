import SwiftUI

struct SelectTopColorsView: View {
    @State private var solidColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    @State private var multiColors: [(Color, Color)] = [(.gray, .mint), (.cyan, .brown), (.indigo, .teal), (.black, .white)]
    @State private var selectedColors: Set<Color> = []
    @State private var selectedMultiColors: Set<Int> = []
    @State private var showSolidColorPicker = false
    @State private var showMultiColorPicker = false
    @State private var newColor: Color = .black
    @State private var newMultiColor1: Color = .gray
    @State private var newMultiColor2: Color = .blue
    @State private var showActualColorPicker = false
    @State private var colorPickerTarget: ColorPickerTarget = .solid

    enum ColorPickerTarget {
        case solid
        case multiLeft
        case multiRight
    }

    var body: some View {
        VStack {
            Spacer().frame(height: 40)
            
            // Title
            Text("Select Colors of Tops You Have")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("'Top' refers to clothing worn on the upper body such as shirt, T-shirt, jacket, etc")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
                .padding(.horizontal, 24)
            
            // Solid Color Section
            SectionTitle(text: "Solid Color")
                .padding(.top, 35)
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
            MultiColorBlockGrid(
                colors: multiColors,
                selectedIndices: $selectedMultiColors,
                onAddColor: {
                    showMultiColorPicker = true
                }
            )
            
            Spacer()
            
            // Continue Button
            Button(action: {
                // Action for continue
            }) {
                Text("Continue")
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
        .sheet(isPresented: $showSolidColorPicker) {
            SolidColorPickerSheet(newColor: $newColor) {
                solidColors.append(newColor)
                showSolidColorPicker = false
            }
        }

        .sheet(isPresented: $showMultiColorPicker) {
            MultiColorPickerSheet(
                newLeftColor: $newMultiColor1,
                newRightColor: $newMultiColor2
            ) {
                multiColors.append((newMultiColor1, newMultiColor2))
                showMultiColorPicker = false
            }
        }
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
        VStack(spacing: 10) {
            let total = colors.count + (onAddColor != nil ? 1 : 0)
            ForEach(0..<rowsNeeded(for: total), id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < colors.count {
                            let color = colors[index]
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
                        } else if index == colors.count, let onAddColor = onAddColor {
                            AddColorBlock(action: onAddColor)
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
    }

    private func rowsNeeded(for count: Int) -> Int {
        (count + columns - 1) / columns
    }
}

struct ColorBlock: View {
    let color: Color
    let isSelected: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: 80, height: 55)
                .cornerRadius(10)
                .overlay(
                    Rectangle()
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                        .cornerRadius(10)
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
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 55)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [5]))
                    )
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.gray)
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
        VStack(spacing: 10) {
            let total = colors.count + (onAddColor != nil ? 1 : 0)
            ForEach(0..<rowsNeeded(for: total), id: \.self) { row in                HStack(spacing: 10) {
                ForEach(0..<columns) { col in
                        let index = row * columns + col
                        if index < colors.count {
                            let colorPair = colors[index]
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
                        } else if index == colors.count, let onAddColor = onAddColor {
                            AddColorBlock(action: onAddColor)
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 0)
    }

    private func rowsNeeded(for count: Int) -> Int {
        (count + columns - 1) / columns
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
            .frame(width: 80, height: 55)
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
