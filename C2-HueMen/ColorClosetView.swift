import SwiftUI

struct ColorClosetView: View {
    // Top Section
    @State private var topSolidColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    @State private var topMultiColors: [(Color, Color)] = [(.gray, .mint), (.cyan, .brown), (.indigo, .teal), (.black, .white)]
    @State private var selectedTopColors: Set<Color> = []
    @State private var selectedTopMultiColors: Set<Int> = []

    // Bottom Section
    @State private var bottomSolidColors: [Color] = [.red, .blue, .green, .yellow]
    @State private var bottomMultiColors: [(Color, Color)] = [(.mint, .gray), (.orange, .purple)]
    @State private var selectedBottomColors: Set<Color> = []
    @State private var selectedBottomMultiColors: Set<Int> = []

    // Add Color Sheets
    @State private var showSolidColorPicker = false
    @State private var showMultiColorPicker = false
    @State private var isAddingToTop = true

    @State private var newColor: Color = .black
    @State private var newMultiColor1: Color = .gray
    @State private var newMultiColor2: Color = .blue
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    //Top section
                    VStack(alignment: .center) {
                        HStack {
                            Image(systemName: "tshirt.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("Top Colors")
                                .font(.title2)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal, 6)

                        HStack {
                            Text("Solid Color")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 6)
                            Spacer()
                        }
                        .padding(.top,1)

                        ColorBlockGrid2(
                            colors: topSolidColors,
                            selectedColors: $selectedTopColors,
                            onAddColor: {
                                isAddingToTop = true
                                showSolidColorPicker = true
                            }
                        )

                        HStack {
                            Text("Multi Color")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 6)
                            Spacer()
                        }
                        .padding(.top,30)

                        MultiColorBlockGrid2(
                            colors: topMultiColors,
                            selectedIndices: $selectedTopMultiColors,
                            onAddColor: {
                                isAddingToTop = true
                                showMultiColorPicker = true
                            }
                        )
                    }
                    .padding(.top, 6.75)
                    .padding(.bottom, 11.25)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        

                    // Bottom section
                    VStack(alignment: .center) {
                        HStack {
                            Image(.bottom2)
                                .resizable()
                                .frame(width: 30, height: 38)
                            Text("Bottom Colors")
                                .font(.title2)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal, 6)

                        HStack {
                            Text("Solid Color")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 6)
                            Spacer()
                        }
                        .padding(.top,1)

                        ColorBlockGrid2(
                            colors: bottomSolidColors,
                            selectedColors: $selectedBottomColors,
                            onAddColor: {
                                isAddingToTop = false
                                showSolidColorPicker = true
                            }
                        )

                        HStack {
                            Text("Multi Color")
                                .font(.system(size: 20, weight: .semibold))
                                .padding(.horizontal, 6)
                            Spacer()
                        }
                        .padding(.top,30)

                        MultiColorBlockGrid2(
                            colors: bottomMultiColors,
                            selectedIndices: $selectedBottomMultiColors,
                            onAddColor: {
                                isAddingToTop = false
                                showMultiColorPicker = true
                            }
                        )
                    }
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    .padding(.top, 24)
                }
                .padding(.horizontal, 14.25)
                .padding(.top, 20)
            }
            .sheet(isPresented: $showSolidColorPicker) {
                SolidColorPickerSheet(newColor: $newColor) {
                    if isAddingToTop {
                        topSolidColors.append(newColor)
                    } else {
                        bottomSolidColors.append(newColor)
                    }
                    showSolidColorPicker = false
                }
            }
            .sheet(isPresented: $showMultiColorPicker) {
                MultiColorPickerSheet(
                    newLeftColor: $newMultiColor1,
                    newRightColor: $newMultiColor2
                ) {
                    if isAddingToTop {
                        topMultiColors.append((newMultiColor1, newMultiColor2))
                    } else {
                        bottomMultiColors.append((newMultiColor1, newMultiColor2))
                    }
                    showMultiColorPicker = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}


// MARK: - Reusable Components

//struct SectionTitle: View {
//    let text: String
//
//    var body: some View {
//        HStack {
//            Text(text)
//                .font(.system(size: 20, weight: .semibold))
//                .padding(.horizontal, 24)
//            Spacer()
//        }
//    }
//}

//struct ColorBlockGrid3: View {
//    let colors: [Color]
//    @Binding var selectedColors: Set<Color>
//    let columns = 4
//    var onAddColor: (() -> Void)? = nil
//
//    var body: some View {
//        VStack(spacing: 10) {
//            let total = colors.count + (onAddColor != nil ? 1 : 0)
//            ForEach(0..<rowsNeeded(for: total), id: \.self) { row in
//                HStack(spacing: 10) {
//                    ForEach(0..<columns, id: \.self) { col in
//                        let index = row * columns + col
//                        if index < colors.count {
//                            let color = colors[index]
//                            ColorBlock2(
//                                color: color,
//                                isSelected: selectedColors.contains(color)
//                            )
//                            .onTapGesture {
//                                if selectedColors.contains(color) {
//                                    selectedColors.remove(color)
//                                } else {
//                                    selectedColors.insert(color)
//                                }
//                            }
//                        } else if index == colors.count, let onAddColor = onAddColor {
//                            AddColorBlock(action: onAddColor)
//                        } else {
//                            Spacer()
//                        }
//                    }
//                }
//            }
//        }
//        .padding(.horizontal, 24)
//        .padding(.top, 0)
//    }
//
//    private func rowsNeeded(for count: Int) -> Int {
//        (count + columns - 1) / columns
//    }
//}

struct ColorBlockGrid2: View {
    let colors: [Color]
    @Binding var selectedColors: Set<Color>
    var onAddColor: (() -> Void)? = nil
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 32), count: 4)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 17) {
            ForEach(colors, id: \.self) { color in
                ColorBlock2(
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
            }
            
            // Optional Add Color Block
            if let onAddColor = onAddColor {
                AddColorBlock2(action: onAddColor)
            }
        }
        .padding(.horizontal)
    }
}
//
struct ColorBlock2: View {
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: 75, height: 58)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.7), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
    }
}
//
struct AddColorBlock2: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(Color.lightGrayPlusButton)
                    .frame(width: 75, height: 58)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black.opacity(0.7), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 4)
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.black.opacity(0.7))
            }
        }
    }
}
//
import SwiftUI

struct MultiColorBlockGrid2: View {
    let colors: [(Color, Color)]
    @Binding var selectedIndices: Set<Int>
    var onAddColor: (() -> Void)? = nil

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 32), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(colors.indices, id: \.self) { index in
                let colorPair = colors[index]
                MultiColorBlock2(
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
            }

            if let onAddColor = onAddColor {
                AddColorBlock2(action: onAddColor)
            }
        }
        .padding(.horizontal)
    }
}


struct MultiColorBlock2: View {
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
                    .stroke(Color.black.opacity(0.7), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
    }
}
//
//struct SolidColorPickerSheet: View {
//    @Binding var newColor: Color
//    var onAdd: () -> Void
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Capsule()
//                .fill(Color.secondary.opacity(0.3))
//                .frame(width: 40, height: 5)
//                .padding(.bottom, 8)
//
//            Text("Add New Solid Color")
//                .font(.headline)
//                .padding(.bottom, 15)
//
//            ColorPicker("", selection: $newColor, supportsOpacity: false)
//                .labelsHidden()
//                .scaleEffect(1.5)
//                .padding(.horizontal, 32)
//                .padding(.bottom, 15)
//
//            Button("Add Color", action: onAdd)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//                .padding(.horizontal, 24)
//                .padding(.bottom, 16)
//        }
//        .presentationDetents([.height(220)])
//    }
//}
//
//struct MultiColorPickerSheet: View {
//    @Binding var newLeftColor: Color
//    @Binding var newRightColor: Color
//    var onAdd: () -> Void
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Capsule()
//                .fill(Color.secondary.opacity(0.3))
//                .frame(width: 40, height: 5)
//                .padding(.top, 8)
//
//            Text("Add New Multi Color")
//                .font(.headline)
//
//            VStack(spacing: 12) {
//                HStack {
//                    Text("Color 1")
//                    ColorPicker("", selection: $newLeftColor, supportsOpacity: false)
//                        .labelsHidden()
//                }
//                HStack {
//                    Text("Color 2")
//                    ColorPicker("", selection: $newRightColor, supportsOpacity: false)
//                        .labelsHidden()
//                }
//            }
//            .padding(.horizontal, 32)
//            .padding(.vertical, 12)
//
//            Button("Add Color", action: onAdd)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//                .padding(.horizontal, 24)
//                .padding(.bottom, 16)
//        }
//        .presentationDetents([.height(250)])
//    }
//}


// MARK: - Preview

#Preview {
    ColorClosetView()
}
