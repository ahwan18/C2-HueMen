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

    @State private var solidBottomColors: [Color] = [.brown, .blue, .gray]
    @State private var multiBottomColors: [(Color, Color)] = [(.brown, .black)]
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
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Solid
                        Text("Solid Color")
                            .font(.headline)
                            .padding(.horizontal)

                        ColorBlockGridSingleSelect(
                            colors: selectedSection == .top ? solidTopColors : solidBottomColors,
                            selectedColor: selectedSection == .top ? $selectedTopColor : $selectedBottomColor
                        )
                        .padding(.bottom, 30)

                        // Multi
                        Text("Multi Color")
                            .font(.headline)
                            .padding(.horizontal)

                        MultiColorBlockGridSingleSelect(
                            colors: selectedSection == .top ? multiTopColors : multiBottomColors,
                            selectedIndex: selectedSection == .top ? $selectedMultiTopIndex : $selectedMultiBottomIndex
                        )
                        
                        Spacer().frame(height: 215)
                                    
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
                        
                        
                    }
                    .padding(.vertical)
                    .padding()
                }
            }
            .navigationTitle("Select 1 Color from Your Wardrobe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ColorBlockGridSingleSelect: View {
    let colors: [Color]
    @Binding var selectedColor: Color?

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
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MultiColorBlockGridSingleSelect: View {
    let colors: [(Color, Color)]
    @Binding var selectedIndex: Int?

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
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ColorClosetSegmentedView()
}
