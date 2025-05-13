//
//  ColorSuggestionView.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 08/05/25.
//
import SwiftUI

struct RecommendationView: View {
    enum Mode {
        case top // user memilih warna pants (bottom)
        case bottom // user memilih warna baju (top)
    }
    
    enum SectionTitle: String {
        case top = "Top Colors"
        case bottom = "Bottom Colors"
    }
    
    let selectedColor: Color
    let uploadType: UploadType
    let colorType: ColorType
    
    @StateObject private var colorManager = ColorClosetManager.shared
    @State private var compatibleColors: [ColorItem] = []
    @State private var mostCompatibleColor: ColorItem?
    @State private var selectedCompatibleColor: ColorItem?
    @State private var isDoneActive = false
    
    // Developer dapat mengubah nilai default di sini:
    @State private var leftWidthRatio: CGFloat = -0.020
    @State private var rightWidthRatio: CGFloat = 1
    
    @State private var showAddToWardrobeAlert = false
    @State private var alertMessage = ""
    
    private func isColorInWardrobe(_ color: Color) -> Bool {
        let wardrobe = uploadType == .top ? colorManager.solidTopColors : colorManager.solidBottomColors
        return wardrobe.contains { existingColor in
            let components1 = UIColor(existingColor).cgColor.components ?? []
            let components2 = UIColor(color).cgColor.components ?? []
            return components1.count == components2.count &&
            zip(components1, components2).allSatisfy { abs($0 - $1) < 0.01 }
        }
    }
    
    private func addColorToWardrobe(_ color: Color) {
        if uploadType == .top {
            colorManager.addSolidTopColor(color)
        } else {
            colorManager.addSolidBottomColor(color)
        }
        alertMessage = "Color has been added to your wardrobe"
        showAddToWardrobeAlert = true
    }
    
    struct StripedShirtView: View {
        let color1: Color
        let color2: Color
        
        var body: some View {
            Image(systemName: "tshirt.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125, height: 120)
                .overlay(
                    GeometryReader { geometry in
                        Path { path in
                            let stripeWidth = geometry.size.width / 10 // Adjust for stripe density
                            for i in 0...Int(geometry.size.width / stripeWidth) {
                                let x = CGFloat(i) * stripeWidth
                                path.move(to: CGPoint(x: x, y: 0))
                                path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                            }
                        }
                        .stroke(color2, lineWidth: geometry.size.width / 20)
                    }
                        .mask(
                            Image(systemName: "tshirt.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                        .allowsHitTesting(false)
                )
                .foregroundColor(color1)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        VStack(spacing: 6) {
                            Text(uploadType == .top ? SectionTitle.bottom.rawValue : SectionTitle.top.rawValue)
                                .foregroundStyle(.black)
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("From your wardrobe")
                                .font(.callout)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if !isColorInWardrobe(selectedColor) && getMultiColorPair(for: selectedColor) == nil {
                            Button(action: {
                                alertMessage = "Do you want to add this new \(uploadType == .top ? "top" : "bottom") color to your wardrobe?"
                                showAddToWardrobeAlert = true
                            }) {
                                Text("Add Color")
                                Image(systemName: "plus")
                                
                            }
                            .foregroundStyle(.white)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 15)
                            .background(.black)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Shirt and Pants Preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.backgroundRecommendation))
                            .shadow(radius: 2)
                            .frame(height: 300)
                        VStack(spacing: 0) {
                            if uploadType == .top {
                                // For top selection
                                if colorType == .multi,
                                    let multiColors = getMultiColorPair(for: selectedColor) {
                                    StripedShirtView(color1: multiColors.0, color2: multiColors.1)
                                } else {
                                    Image(systemName: "tshirt.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 125, height: 120)
                                        .foregroundColor(selectedColor)
                                }
                            } else {
                                // For bottom selection
                                if let compatibleMultiColors = getMultiColorPair(for: selectedCompatibleColor?.color ?? selectedColor) {
                                    StripedShirtView(color1: compatibleMultiColors.0, color2: compatibleMultiColors.1)
                                } else {
                                    Image(systemName: "tshirt.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 125, height: 120)
                                        .foregroundColor(selectedCompatibleColor?.color ?? selectedColor)
                                }
                            }
                            
                            PantsShape(leftWidthRatio: leftWidthRatio, rightWidthRatio: rightWidthRatio)
                                .fill(uploadType == .top ? (selectedCompatibleColor?.color ?? selectedColor) : selectedColor)
                                .frame(width: 70, height: 145)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Compatibility Palette
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Most compatible:")
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        HStack(alignment: .center, spacing: 16) {
                            if let mostCompatible = mostCompatibleColor {
                                ColorBlocks(color: mostCompatible.color, isSelected: selectedCompatibleColor?.id == mostCompatible.id)
                                    .onTapGesture {
                                        selectedCompatibleColor = mostCompatible
                                    }
                            }
                            Spacer()
                        }
                        
                        if !compatibleColors.isEmpty {
                            Text("Other compatible colors:")
                                .foregroundStyle(.black)
                            HStack(alignment: .center, spacing: 16) {
                                ForEach(compatibleColors) { colorItem in
                                    if colorItem.id != mostCompatibleColor?.id {
                                        ColorBlocks(color: colorItem.color, isSelected: selectedCompatibleColor?.id == colorItem.id)
                                            .onTapGesture {
                                                selectedCompatibleColor = colorItem
                                            }
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.backgroundRecommendation))
                    .cornerRadius(16)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Done button
                    Button("Done") {
                        isDoneActive = true
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    NavigationLink(destination: HomeScreen(), isActive: $isDoneActive) {
                        EmptyView()
                    }
                }
                .navigationBarBackButtonHidden()
                .padding(.top)
                .onAppear {
                    updateCompatibleColors()
                }
            }
        }
        .alert("Add Color to Wardrobe", isPresented: $showAddToWardrobeAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Add") {
                addColorToWardrobe(selectedColor)
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func updateCompatibleColors() {
        let wardrobe = uploadType == .top ? colorManager.solidBottomColors : colorManager.solidTopColors
        
        // Get compatible colors using color theory
        let allCompatibleColors = ColorTheoryManager.shared.getCompatibleColors(from: wardrobe, for: selectedColor)
        
        // Get most compatible color
        let mostCompatible = ColorTheoryManager.shared.getMostCompatibleColor(from: wardrobe, for: selectedColor)
        mostCompatibleColor = mostCompatible.map { ColorItem(color: $0) }
        
        // Limit compatible colors to 4, excluding the most compatible color
        compatibleColors = allCompatibleColors
            .filter { $0 != mostCompatible }
            .prefix(4)
            .map { ColorItem(color: $0) }
        
        // Set initial selected compatible color
        selectedCompatibleColor = mostCompatibleColor
        
        print("Selected color: \(selectedColor)")
        print("Wardrobe colors: \(wardrobe)")
        print("Compatible colors: \(compatibleColors)")
        print("Most compatible: \(String(describing: mostCompatibleColor))")
        print("Color Type: ", colorType)
    }
    
    private func getMultiColorPair(for color: Color) -> (Color, Color)? {
        let multiColors = uploadType == .top ? colorManager.multiTopColors : colorManager.multiBottomColors
        return multiColors.first { pair in
            let components1 = UIColor(pair.0).cgColor.components ?? []
            let components2 = UIColor(color).cgColor.components ?? []
            return components1.count == components2.count &&
            zip(components1, components2).allSatisfy { abs($0 - $1) < 0.01 }
        }
    }
    
    struct ColorBlocks: View {
        let color: Color
        let isSelected: Bool
        
        var body: some View {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
        }
    }
    
    struct PantsShape: Shape {
        var leftWidthRatio: CGFloat = 0.0   // 0.0 (paling kiri) sampai 0.4 (lebih ke tengah)
        var rightWidthRatio: CGFloat = 1.0  // 0.6 (lebih ke tengah) sampai 1.0 (paling kanan)
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let width = rect.width
            let height = rect.height
            
            // Titik kiri atas dan kanan atas bisa diubah
            let leftTopX = width * leftWidthRatio
            let rightTopX = width * rightWidthRatio
            
            path.move(to: CGPoint(x: leftTopX, y: 0)) // kiri atas
            path.addLine(to: CGPoint(x: 0, y: height)) // kiri bawah
            path.addLine(to: CGPoint(x: width * 0.35, y: height)) // bawah bagian dalam kiri
            
            // Lekukan di tengah (area selangkangan)
            path.addQuadCurve(to: CGPoint(x: width * 0.65, y: height),
                              control: CGPoint(x: width * 0.48, y: height * -0.45))
            
            path.addLine(to: CGPoint(x: width, y: height)) // bawah bagian dalam kanan
            path.addLine(to: CGPoint(x: rightTopX, y: 0)) // kanan atas
            path.closeSubpath()
            
            return path
        }
    }
    
    struct ColorItem: Identifiable, Hashable {
        let id = UUID()
        let color: Color
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: ColorItem, rhs: ColorItem) -> Bool {
            lhs.id == rhs.id
        }
    }
}

#Preview {
    RecommendationView(selectedColor: .brown, uploadType: .top, colorType: .solid)
}
