import SwiftUI

struct ColorClosetView: View {
    enum ClosetSection: String, CaseIterable {
        case top = "Top"
        case bottom = "Bottom"
    }

    @State private var selectedSection: ClosetSection = .top

    // Color States
    @State private var solidTopColors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
    @State private var multiTopColors: [(Color, Color)] = [(.gray, .mint), (.cyan, .brown), (.indigo, .teal), (.black, .white)]
    @State private var selectedTopColors: Set<Color> = []
    @State private var selectedTopMultiColors: Set<Int> = []

    @State private var solidBottomColors: [Color] = [.red, .blue, .green, .yellow]
    @State private var multiBottomColors: [(Color, Color)] = [(.mint, .gray), (.orange, .purple)]
    @State private var selectedBottomColors: Set<Color> = []
    @State private var selectedBottomMultiColors: Set<Int> = []

    // Sheet State
    @State private var showSolidColorPicker = false
    @State private var showMultiColorPicker = false
    @State private var isAddingToTop = true
    @State private var newColor: Color = .black
    @State private var newMultiColor1: Color = .gray
    @State private var newMultiColor2: Color = .blue

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedSection) {
                    ForEach(ClosetSection.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ScrollView {
                    VStack(spacing: 24) {
                        if selectedSection == .top {
                            closetSectionView(
                                icon: Image(systemName: "tshirt.circle"),
                                title: "Top Colors",
                                solidColors: $solidTopColors,
                                selectedColors: $selectedTopColors,
                                multiColors: $multiTopColors,
                                selectedMultiIndices: $selectedTopMultiColors,
                                isTop: true
                            )
                        } else {
                            closetSectionView(
                                icon: Image(.bottom2),
                                title: "Bottom Colors",
                                solidColors: $solidBottomColors,
                                selectedColors: $selectedBottomColors,
                                multiColors: $multiBottomColors,
                                selectedMultiIndices: $selectedBottomMultiColors,
                                isTop: false
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .onChange(of: selectedSection) { newValue in
                    // Clear selections when switching tab
                    selectedTopColors.removeAll()
                    selectedTopMultiColors.removeAll()
                    selectedBottomColors.removeAll()
                    selectedBottomMultiColors.removeAll()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(true)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { dismiss() }) {
//                        HStack(spacing: 4) {
//                            Image(systemName: "chevron.left")
//                                .font(.system(size: 17, weight: .semibold))
//                            Text("Back")
//                                .font(.system(size: 17))
//                        }
//                        .foregroundColor(.black)
//                    }
//                }
//            }
            .sheet(isPresented: $showSolidColorPicker) {
                SolidColorPickerSheet(newColor: $newColor) {
                    if isAddingToTop {
                        solidTopColors.append(newColor)
                    } else {
                        solidBottomColors.append(newColor)
                    }
                    showSolidColorPicker = false
                }
            }
            .sheet(isPresented: $showMultiColorPicker) {
                MultiColorPickerSheet(newLeftColor: $newMultiColor1, newRightColor: $newMultiColor2) {
                    if isAddingToTop {
                        multiTopColors.append((newMultiColor1, newMultiColor2))
                    } else {
                        multiBottomColors.append((newMultiColor1, newMultiColor2))
                    }
                    showMultiColorPicker = false
                }
            }
        }
    }

    @ViewBuilder
    private func closetSectionView(
        icon: Image,
        title: String,
        solidColors: Binding<[Color]>,
        selectedColors: Binding<Set<Color>>,
        multiColors: Binding<[(Color, Color)]>,
        selectedMultiIndices: Binding<Set<Int>>,
        isTop: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                icon
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.leading, 22)
            .padding(.bottom, 20)

            Text("Solid Color")
                .font(.headline)
                .padding(.leading, 22)
                .padding(.bottom, 10)

            ClosetColorBlockGrid(
                colors: solidColors,
                selectedColors: selectedColors,
                onAddColor: {
                    isAddingToTop = isTop
                    showSolidColorPicker = true
                },
                onSelect: {
                    selectedMultiIndices.wrappedValue.removeAll() // Unselect multi when solid is tapped
                }
            )

            Text("Multi Color")
                .font(.headline)
                .padding(.leading, 22)
                .padding(.bottom, 10)

            ClosetMultiColorBlockGrid(
                colors: multiColors,
                selectedIndices: selectedMultiIndices,
                onAddColor: {
                    isAddingToTop = isTop
                    showMultiColorPicker = true
                },
                onSelect: {
                    selectedColors.wrappedValue.removeAll() // Unselect solid when multi is tapped
                }
            )

        }
        .padding()
    }
}

struct ClosetColorBlockGrid: View {
    @Binding var colors: [Color]
    @Binding var selectedColors: Set<Color>
    let columns = 4
    var onAddColor: (() -> Void)? = nil
    var onSelect: (() -> Void)? = nil // NEW

    var body: some View {
        VStack(spacing: 10) {
            let total = colors.count + (onAddColor != nil ? 1 : 0)
            ForEach(0..<rowsNeeded(for: total), id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < colors.count {
                            let color = colors[index]
                            ClosetColorBlock(
                                color: color,
                                isSelected: selectedColors.contains(color),
                                onDelete: {
                                    colors.removeAll { $0 == color }
                                    selectedColors.remove(color)
                                }
                            )
                            .onTapGesture {
                                if selectedColors.contains(color) {
                                    selectedColors.removeAll()
                                } else {
                                    selectedColors = [color]
                                    onSelect?() // clear multi
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
        .padding(.bottom, 25)
    }

    private func rowsNeeded(for count: Int) -> Int {
        (count + columns - 1) / columns
    }
}

struct ClosetColorBlock: View {
    let color: Color
    let isSelected: Bool
    var onDelete: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: 80, height: 55)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

            if isSelected {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.blue))
                            .font(.system(size: 16))
                            .padding(4)
                    }
                    Spacer()
                    HStack {
                        Button(action: { onDelete?() }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        .padding(4)
                        Spacer()
                    }
                }
                .frame(width: 80, height: 55)
            }
        }
    }
}


struct ClosetMultiColorBlockGrid: View {
    @Binding var colors: [(Color, Color)]
    @Binding var selectedIndices: Set<Int>
    let columns = 4
    var onAddColor: (() -> Void)? = nil
    var onSelect: (() -> Void)? = nil // NEW

    var body: some View {
        VStack(spacing: 10) {
            let total = colors.count + (onAddColor != nil ? 1 : 0)
            ForEach(0..<rowsNeeded(for: total), id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < colors.count {
                            let colorPair = colors[index]
                            ClosetMultiColorBlock(
                                leftColor: colorPair.0,
                                rightColor: colorPair.1,
                                isSelected: selectedIndices.contains(index),
                                onDelete: {
                                    colors.remove(at: index)
                                    selectedIndices.remove(index)
                                }
                            )
                            .onTapGesture {
                                if selectedIndices.contains(index) {
                                    selectedIndices.removeAll()
                                } else {
                                    selectedIndices = [index]
                                    onSelect?() // clear solid
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
    }

    private func rowsNeeded(for count: Int) -> Int {
        (count + columns - 1) / columns
    }
}


struct ClosetMultiColorBlock: View {
    let leftColor: Color
    let rightColor: Color
    let isSelected: Bool
    var onDelete: (() -> Void)? = nil

    var body: some View {
        ZStack {
            // Background: dua warna
            HStack(spacing: 0) {
                Rectangle().fill(leftColor)
                Rectangle().fill(rightColor)
            }
            .frame(width: 80, height: 55)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

            // Overlay Icons
            if isSelected {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.blue))
                            .font(.system(size: 16))
                            .padding(4)
                    }
                    Spacer()
                    HStack {
                        Button(action: { onDelete?() }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .padding(4)
                                .background(Color.red)
                                .clipShape(Circle())
                        }
                        .padding(4)
                        Spacer()
                    }
                }
                .frame(width: 80, height: 55) // Match block size
            }
        }
    }
}






#Preview {
    ColorClosetView()
}
