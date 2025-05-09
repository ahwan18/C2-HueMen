import SwiftUI

struct ColorClosetSegmentedView: View {
    enum ClosetSection: String, CaseIterable {
        case top = "Top"
        case bottom = "Bottom"
    }
    
    @StateObject private var colorManager = ColorClosetManager.shared
    @State private var selectedSection: ClosetSection = .top
    @State private var selectedItem: SelectedItem? = nil
    @State private var showRecommendation = false
    
    enum SelectedItem {
        case solidTop(Color)
        case multiTop(Int)
        case solidBottom(Color)
        case multiBottom(Int)
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
                        Text("Solid Color")
                            .font(.headline)
                            .padding(.horizontal)

                        if selectedSection == .top {
                            ColorBlockGridSingleSelect(
                                colors: colorManager.solidTopColors,
                                selectedColor: selectedItem.flatMap { sel in
                                    if case let .solidTop(color) = sel { return color } else { return nil }
                                },
                                onSelect: { color in
                                    selectedItem = .solidTop(color)
                                }
                            )
                            .padding(.bottom, 30)
                        } else {
                            ColorBlockGridSingleSelect(
                                colors: colorManager.solidBottomColors,
                                selectedColor: selectedItem.flatMap { sel in
                                    if case let .solidBottom(color) = sel { return color } else { return nil }
                                },
                                onSelect: { color in
                                    selectedItem = .solidBottom(color)
                                }
                            )
                            .padding(.bottom, 30)
                        }

                        Text("Multi Color")
                            .font(.headline)
                            .padding(.horizontal)

                        if selectedSection == .top {
                            MultiColorBlockGridSingleSelect(
                                colors: colorManager.multiTopColors,
                                selectedIndex: selectedItem.flatMap { sel in
                                    if case let .multiTop(idx) = sel { return idx } else { return nil }
                                },
                                onSelect: { idx in
                                    selectedItem = .multiTop(idx)
                                }
                            )
                        } else {
                            MultiColorBlockGridSingleSelect(
                                colors: colorManager.multiBottomColors,
                                selectedIndex: selectedItem.flatMap { sel in
                                    if case let .multiBottom(idx) = sel { return idx } else { return nil }
                                },
                                onSelect: { idx in
                                    selectedItem = .multiBottom(idx)
                                }
                            )
                        }
                        Spacer().frame(height: 215)
                        
                        Button(action: {
                            showRecommendation = true
                        }) {
                            Text("Continue")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(14)
                        }
                        .disabled(selectedItem == nil)
                        
                        if let params = getRecommendationParams() {
                            NavigationLink(
                                destination: RecommendationView(selectedColor: params.color, uploadType: params.uploadType),
                                isActive: $showRecommendation
                            ) {
                                EmptyView()
                            }
                        }
                    }
                    .padding(.vertical)
                    .padding()
                }
            }
            .navigationTitle("Select 1 Color from Your Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
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

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Rectangle()
                        .fill(color)
                        .frame(width: 70, height: 55)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 2)
                        )
                        .shadow(radius: 2)
                }
                .onTapGesture {
                    onSelect(color)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MultiColorBlockGridSingleSelect: View {
    let colors: [(Color, Color)]
    let selectedIndex: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
            ForEach(colors.indices, id: \.self) { index in
                let pair = colors[index]
                ZStack {
                    HStack(spacing: 0) {
                        Rectangle().fill(pair.0)
                        Rectangle().fill(pair.1)
                    }
                    .frame(width: 70, height: 55)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                    )
                    .shadow(radius: 2)
                }
                .onTapGesture {
                    onSelect(index)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ColorClosetSegmentedView()
}
