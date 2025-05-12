import SwiftUI

class ColorClosetManager: ObservableObject {
    @Published var solidTopColors: [Color] = []
    @Published var multiTopColors: [(Color, Color)] = []
    @Published var solidBottomColors: [Color] = []
    @Published var multiBottomColors: [(Color, Color)] = []
    
    static let shared = ColorClosetManager()
    
    private init() {
        loadColors()
    }
    
    private func loadColors() {
        // Load solid top colors
        if let topColorsData = UserDefaults.standard.array(forKey: "solidTopColors") as? [[CGFloat]] {
            solidTopColors = topColorsData.compactMap { components in
                guard components.count == 4 else { return nil }
                return Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
            }
        }
        
        // Load multi top colors
        if let multiTopColorsData = UserDefaults.standard.array(forKey: "multiTopColors") as? [[[CGFloat]]] {
            multiTopColors = multiTopColorsData.compactMap { pair in
                guard pair.count == 2,
                      pair[0].count == 4,
                      pair[1].count == 4 else { return nil }
                let color1 = Color(.sRGB, red: pair[0][0], green: pair[0][1], blue: pair[0][2], opacity: pair[0][3])
                let color2 = Color(.sRGB, red: pair[1][0], green: pair[1][1], blue: pair[1][2], opacity: pair[1][3])
                return (color1, color2)
            }
        }
        
        // Load solid bottom colors
        if let bottomColorsData = UserDefaults.standard.array(forKey: "solidBottomColors") as? [[CGFloat]] {
            solidBottomColors = bottomColorsData.compactMap { components in
                guard components.count == 4 else { return nil }
                return Color(.sRGB, red: components[0], green: components[1], blue: components[2], opacity: components[3])
            }
        }
        
        // Load multi bottom colors
        if let multiBottomColorsData = UserDefaults.standard.array(forKey: "multiBottomColors") as? [[[CGFloat]]] {
            multiBottomColors = multiBottomColorsData.compactMap { pair in
                guard pair.count == 2,
                      pair[0].count == 4,
                      pair[1].count == 4 else { return nil }
                let color1 = Color(.sRGB, red: pair[0][0], green: pair[0][1], blue: pair[0][2], opacity: pair[0][3])
                let color2 = Color(.sRGB, red: pair[1][0], green: pair[1][1], blue: pair[1][2], opacity: pair[1][3])
                return (color1, color2)
            }
        }
    }
    
    private func saveColors() {
        // Save solid top colors
        let topColorsData = solidTopColors.map { color -> [CGFloat] in
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var opacity: CGFloat = 0
            UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
            return [red, green, blue, opacity]
        }
        UserDefaults.standard.set(topColorsData, forKey: "solidTopColors")
        
        // Save multi top colors
        let multiTopColorsData = multiTopColors.map { pair -> [[CGFloat]] in
            var red1: CGFloat = 0
            var green1: CGFloat = 0
            var blue1: CGFloat = 0
            var opacity1: CGFloat = 0
            UIColor(pair.0).getRed(&red1, green: &green1, blue: &blue1, alpha: &opacity1)
            
            var red2: CGFloat = 0
            var green2: CGFloat = 0
            var blue2: CGFloat = 0
            var opacity2: CGFloat = 0
            UIColor(pair.1).getRed(&red2, green: &green2, blue: &blue2, alpha: &opacity2)
            
            return [[red1, green1, blue1, opacity1], [red2, green2, blue2, opacity2]]
        }
        UserDefaults.standard.set(multiTopColorsData, forKey: "multiTopColors")
        
        // Save solid bottom colors
        let bottomColorsData = solidBottomColors.map { color -> [CGFloat] in
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var opacity: CGFloat = 0
            UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
            return [red, green, blue, opacity]
        }
        UserDefaults.standard.set(bottomColorsData, forKey: "solidBottomColors")
        
        // Save multi bottom colors
        let multiBottomColorsData = multiBottomColors.map { pair -> [[CGFloat]] in
            var red1: CGFloat = 0
            var green1: CGFloat = 0
            var blue1: CGFloat = 0
            var opacity1: CGFloat = 0
            UIColor(pair.0).getRed(&red1, green: &green1, blue: &blue1, alpha: &opacity1)
            
            var red2: CGFloat = 0
            var green2: CGFloat = 0
            var blue2: CGFloat = 0
            var opacity2: CGFloat = 0
            UIColor(pair.1).getRed(&red2, green: &green2, blue: &blue2, alpha: &opacity2)
            
            return [[red1, green1, blue1, opacity1], [red2, green2, blue2, opacity2]]
        }
        UserDefaults.standard.set(multiBottomColorsData, forKey: "multiBottomColors")
    }
    
    func addSolidTopColor(_ color: Color) {
        solidTopColors.append(color)
        saveColors()
    }
    
    func addMultiTopColor(_ colors: (Color, Color)) {
        multiTopColors.append(colors)
        saveColors()
    }
    
    func addSolidBottomColor(_ color: Color) {
        solidBottomColors.append(color)
        saveColors()
    }
    
    func addMultiBottomColor(_ colors: (Color, Color)) {
        multiBottomColors.append(colors)
        saveColors()
    }
    
    func removeSolidTopColor(_ color: Color) {
        solidTopColors.removeAll { $0 == color }
        saveColors()
    }
    
    func removeMultiTopColor(at index: Int) {
        if index < multiTopColors.count {
            multiTopColors.remove(at: index)
            saveColors()
        }
    }
    
    func removeSolidBottomColor(_ color: Color) {
        solidBottomColors.removeAll { $0 == color }
        saveColors()
    }
    
    func removeMultiBottomColor(at index: Int) {
        if index < multiBottomColors.count {
            multiBottomColors.remove(at: index)
            saveColors()
        }
    }
    
    func updateFromSetup(topSolidColors: [Color], topMultiColors: [(Color, Color)], bottomSolidColors: [Color], bottomMultiColors: [(Color, Color)]) {
        solidTopColors = topSolidColors
        multiTopColors = topMultiColors
        solidBottomColors = bottomSolidColors
        multiBottomColors = bottomMultiColors
        saveColors()
    }
}

struct ColorClosetSegmentedView: View {
    enum ClosetSection: String, CaseIterable {
        case top = "Top"
        case bottom = "Bottom"
    }
    
    @StateObject private var colorManager = ColorClosetManager.shared
    @State private var selectedSection: ClosetSection = .top
    @State private var selectedItem: SelectedItem? = nil
    @State private var showRecommendation = false
    
    // Add new state variables for color pickers
    @State private var showSolidColorPicker = false
    @State private var showMultiColorPicker = false
    @State private var newColor: Color = .black
    @State private var newMultiColor1: Color = .gray
    @State private var newMultiColor2: Color = .blue
    
    // Add alert state
    @State private var showDuplicateAlert = false
    @State private var alertMessage = ""
    
    enum SelectedItem {
        case solidTop(Color)
        case multiTop(Int)
        case solidBottom(Color)
        case multiBottom(Int)
    }
    
    // Add function to check for duplicate colors
    private func isDuplicateSolidColor(_ color: Color) -> Bool {
        let colors = selectedSection == .top ? colorManager.solidTopColors : colorManager.solidBottomColors
        return colors.contains { existingColor in
            let components1 = UIColor(existingColor).cgColor.components ?? []
            let components2 = UIColor(color).cgColor.components ?? []
            return components1.count == components2.count &&
                   zip(components1, components2).allSatisfy { abs($0 - $1) < 0.01 }
        }
    }
    
    private func isDuplicateMultiColor(_ colors: (Color, Color)) -> Bool {
        let multiColors = selectedSection == .top ? colorManager.multiTopColors : colorManager.multiBottomColors
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
            VStack(spacing: 0) {
                Picker("Section", selection: $selectedSection) {
                    ForEach(ClosetSection.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Solid Color")
                                .font(.headline)
                            Spacer()
                            // Show delete button only if a solid color is selected
                            if let selectedItem = selectedItem, case .solidTop(_) = selectedItem, selectedSection == .top {
                                Button(action: {
                                    if case let .solidTop(color) = selectedItem {
                                        colorManager.removeSolidTopColor(color)
                                        self.selectedItem = nil
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            } else if let selectedItem = selectedItem, case .solidBottom(_) = selectedItem, selectedSection == .bottom {
                                Button(action: {
                                    if case let .solidBottom(color) = selectedItem {
                                        colorManager.removeSolidBottomColor(color)
                                        self.selectedItem = nil
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.horizontal)

                        if selectedSection == .top {
                            ColorBlockGridSingleSelect(
                                colors: colorManager.solidTopColors,
                                selectedColor: selectedItem.flatMap { sel in
                                    if case let .solidTop(color) = sel { return color } else { return nil }
                                },
                                onSelect: { color in
                                    if case let .solidTop(selectedColor) = selectedItem, selectedColor == color {
                                        selectedItem = nil
                                    } else {
                                        selectedItem = .solidTop(color)
                                    }
                                },
                                onAddColor: {
                                    showSolidColorPicker = true
                                },
                                onDelete: { _ in }
                            )
                            .padding(.bottom, 30)
                        } else {
                            ColorBlockGridSingleSelect(
                                colors: colorManager.solidBottomColors,
                                selectedColor: selectedItem.flatMap { sel in
                                    if case let .solidBottom(color) = sel { return color } else { return nil }
                                },
                                onSelect: { color in
                                    if case let .solidBottom(selectedColor) = selectedItem, selectedColor == color {
                                        selectedItem = nil
                                    } else {
                                        selectedItem = .solidBottom(color)
                                    }
                                },
                                onAddColor: {
                                    showSolidColorPicker = true
                                },
                                onDelete: { _ in }
                            )
                            .padding(.bottom, 30)
                        }

                        HStack {
                            Text("Multi Color")
                                .font(.headline)
                            Spacer()
                            // Show delete button only if a multi color is selected
                            if let selectedItem = selectedItem, case .multiTop(_) = selectedItem, selectedSection == .top {
                                Button(action: {
                                    if case let .multiTop(index) = selectedItem {
                                        colorManager.removeMultiTopColor(at: index)
                                        self.selectedItem = nil
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            } else if let selectedItem = selectedItem, case .multiBottom(_) = selectedItem, selectedSection == .bottom {
                                Button(action: {
                                    if case let .multiBottom(index) = selectedItem {
                                        colorManager.removeMultiBottomColor(at: index)
                                        self.selectedItem = nil
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .padding(.horizontal)

                        if selectedSection == .top {
                            MultiColorBlockGridSingleSelect(
                                colors: colorManager.multiTopColors,
                                selectedIndex: selectedItem.flatMap { sel in
                                    if case let .multiTop(idx) = sel { return idx } else { return nil }
                                },
                                onSelect: { idx in
                                    if case let .multiTop(selectedIdx) = selectedItem, selectedIdx == idx {
                                        selectedItem = nil
                                    } else {
                                        selectedItem = .multiTop(idx)
                                    }
                                },
                                onAddColor: {
                                    showMultiColorPicker = true
                                },
                                onDelete: { _ in }
                            )
                        } else {
                            MultiColorBlockGridSingleSelect(
                                colors: colorManager.multiBottomColors,
                                selectedIndex: selectedItem.flatMap { sel in
                                    if case let .multiBottom(idx) = sel { return idx } else { return nil }
                                },
                                onSelect: { idx in
                                    if case let .multiBottom(selectedIdx) = selectedItem, selectedIdx == idx {
                                        selectedItem = nil
                                    } else {
                                        selectedItem = .multiBottom(idx)
                                    }
                                },
                                onAddColor: {
                                    showMultiColorPicker = true
                                },
                                onDelete: { _ in }
                            )
                        }
                    }
                    .padding(.top, 30)
                }

                VStack {
                    Button(action: {
                        showRecommendation = true
                    }) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedItem == nil ? Color.gray : Color.black)
                            .cornerRadius(14)
                    }
                    .disabled(selectedItem == nil)
                    .opacity(selectedItem == nil ? 0.6 : 1.0)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    if let params = getRecommendationParams() {
                        NavigationLink(
                            destination: RecommendationView(selectedColor: params.color, uploadType: params.uploadType)
                                .navigationBarBackButtonHidden(true),
                            isActive: $showRecommendation
                        ) {
                            EmptyView()
                        }
                    }
                }
                .background(Color.white)
            }
            .navigationTitle("Select 1 Color from Your Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .navigationViewStyle(.stack)
            .sheet(isPresented: $showSolidColorPicker) {
                SolidColorPickerSheet(newColor: $newColor) {
                    if isDuplicateSolidColor(newColor) {
                        alertMessage = "This color already exists in your wardrobe"
                        showDuplicateAlert = true
                    } else {
                        if selectedSection == .top {
                            colorManager.addSolidTopColor(newColor)
                            selectedItem = .solidTop(newColor)
                        } else {
                            colorManager.addSolidBottomColor(newColor)
                            selectedItem = .solidBottom(newColor)
                        }
                        showSolidColorPicker = false
                    }
                }
            }
            .sheet(isPresented: $showMultiColorPicker) {
                MultiColorPickerSheet(newLeftColor: $newMultiColor1, newRightColor: $newMultiColor2) {
                    if isDuplicateMultiColor((newMultiColor1, newMultiColor2)) {
                        alertMessage = "This color combination already exists in your wardrobe"
                        showDuplicateAlert = true
                    } else {
                        if selectedSection == .top {
                            colorManager.addMultiTopColor((newMultiColor1, newMultiColor2))
                            selectedItem = .multiTop(colorManager.multiTopColors.count - 1)
                        } else {
                            colorManager.addMultiBottomColor((newMultiColor1, newMultiColor2))
                            selectedItem = .multiBottom(colorManager.multiBottomColors.count - 1)
                        }
                        showMultiColorPicker = false
                    }
                }
            }
            .alert("Duplicate Color", isPresented: $showDuplicateAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func getRecommendationParams() -> (color: Color, uploadType: UploadType)? {
        guard let selected = selectedItem else { return nil }
        
        switch selected {
        case .solidTop(let color):
            return (color, .top)
        case .multiTop(let index):
            guard index < colorManager.multiTopColors.count else { return nil }
            return (colorManager.multiTopColors[index].0, .top)
        case .solidBottom(let color):
            return (color, .bottom)
        case .multiBottom(let index):
            guard index < colorManager.multiBottomColors.count else { return nil }
            return (colorManager.multiBottomColors[index].0, .bottom)
        }
    }
}

struct ColorBlockGridSingleSelect: View {
    let colors: [Color]
    let selectedColor: Color?
    let onSelect: (Color) -> Void
    let onAddColor: () -> Void
    let onDelete: (Color) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Rectangle()
                        .fill(color)
                        .frame(width: 75, height: 55)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    
                    if selectedColor == color {
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
                        }
                        .frame(width: 75, height: 55)
                    }
                }
                .onTapGesture {
                    if selectedColor == color {
                        onSelect(color) // This will trigger unselect since the color is already selected
                    } else {
                        onSelect(color)
                    }
                }
            }
            
            AddColorBlock(action: onAddColor as () -> Void)
                .frame(width: 75, height: 55)
        }
        .padding(.horizontal)
    }
}

struct MultiColorBlockGridSingleSelect: View {
    let colors: [(Color, Color)]
    let selectedIndex: Int?
    let onSelect: (Int) -> Void
    let onAddColor: () -> Void
    let onDelete: (Int) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
            ForEach(colors.indices, id: \.self) { index in
                let pair = colors[index]
                ZStack {
                    HStack(spacing: 0) {
                        Rectangle().fill(pair.0)
                        Rectangle().fill(pair.1)
                    }
                    .frame(width: 75, height: 55)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
                    
                    if selectedIndex == index {
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
                        }
                        .frame(width: 75, height: 55)
                    }
                }
                .onTapGesture {
                    if selectedIndex == index {
                        onSelect(index) // This will trigger unselect since the index is already selected
                    } else {
                        onSelect(index)
                    }
                }
            }
            
            AddColorBlock(action: onAddColor as () -> Void)
                .frame(width: 75, height: 55)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ColorClosetSegmentedView()
}
