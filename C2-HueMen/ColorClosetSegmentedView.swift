import SwiftUI

enum ClosetSection: String, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
}

struct ColorClosetSegmentedView: View {
    @State private var selectedSection: ClosetSection = .top

    @State private var solidTopColors: [Color] = [.white, .black, .gray, Color(red: 0.0, green: 0.2, blue: 0.4), Color(red: 0.7, green: 0.85, blue: 1.0), .brown]
    @State private var multiTopColors: [(Color, Color)] = [(.white, .blue), (.gray, .black), (.blue, Color(red: 0.7, green: 0.85, blue: 1.0)), (.white, .gray)]
    @State private var selectedTopColor: Color? = nil
    @State private var selectedMultiTopIndex: Int? = nil

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
    @State private var selectedBottomColor: Color? = nil
    @State private var selectedMultiBottomIndex: Int? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented control
                Picker("Section", selection: $selectedSection) {
                    ForEach(ClosetSection.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 28)
                .padding(.top, 15)
                .padding(.bottom, 0)

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Solid
                        Text("Solid Color")
                            .font(.headline)
                            .padding(.horizontal)

                        ColorBlockGridSingleSelect(
                            colors: selectedSection == .top ? solidTopColors : solidBottomColors,
                            selectedColor: selectedSection == .top ? $selectedTopColor : $selectedBottomColor,
                            onSelect: {
                                if selectedSection == .top {
                                    resetBottomSelections()
                                    selectedMultiTopIndex = nil // ✅ clear multi if solid selected
                                } else {
                                    resetTopSelections()
                                    selectedMultiBottomIndex = nil
                                }
                            }
                        )

                        // Multi
                        Text("Multi Color")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 30)

                        MultiColorBlockGridSingleSelect(
                            colors: selectedSection == .top ? multiTopColors : multiBottomColors,
                            selectedIndex: selectedSection == .top ? $selectedMultiTopIndex : $selectedMultiBottomIndex,
                            onSelect: {
                                if selectedSection == .top {
                                    resetBottomSelections()
                                    selectedTopColor = nil // ✅ clear solid if multi selected
                                } else {
                                    resetTopSelections()
                                    selectedBottomColor = nil
                                }
                            }
                        )
                        
                        Spacer().frame(height: 235)

                        Button(action: {
                            // Handle Next Action
                        }) {
                            Text("Next")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black)
                                .cornerRadius(14)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.vertical)
                    .padding()
                }
            }
            .navigationTitle("Select 1 Color from Your Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Tambahkan di dalam ColorClosetSegmentedView
    private func resetTopSelections() {
        selectedTopColor = nil
        selectedMultiTopIndex = nil
    }

    private func resetBottomSelections() {
        selectedBottomColor = nil
        selectedMultiBottomIndex = nil
    }
}

struct ColorBlockGridSingleSelect: View {
    let colors: [Color]
    @Binding var selectedColor: Color?
    var onSelect: () -> Void = {} // ✅ tambahkan closure

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
                    selectedColor = (selectedColor == color) ? nil : color
                    onSelect() // ✅ reset multi color
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MultiColorBlockGridSingleSelect: View {
    let colors: [(Color, Color)]
    @Binding var selectedIndex: Int?
    var onSelect: () -> Void = {} // ✅

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
                    selectedIndex = (selectedIndex == index) ? nil : index
                    onSelect() // ✅ reset solid color
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ColorClosetSegmentedView()
}
