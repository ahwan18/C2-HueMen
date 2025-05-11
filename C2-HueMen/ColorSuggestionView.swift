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
    
    @StateObject private var colorManager = ColorClosetManager.shared
    @State private var compatibleColors: [Color] = []
    @State private var mostCompatibleColor: Color?
    @State private var selectedCompatibleColor: Color?
    @State private var isDoneActive = false
    
    // Developer dapat mengubah nilai default di sini:
    @State private var leftWidthRatio: CGFloat = -0.020
    @State private var rightWidthRatio: CGFloat = 1
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 6) {
                        Text(uploadType == .top ? SectionTitle.bottom.rawValue : SectionTitle.top.rawValue)
                            .foregroundStyle(.black)
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // Shirt and Pants Preview
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.backgroundRecommendation))
                            .shadow(radius: 2)
                            .frame(height: 370)
                        VStack(spacing: 0) {
                            Image(systemName: "tshirt.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 125, height: 120)
                                .foregroundColor(uploadType == .top ? selectedColor : (selectedCompatibleColor ?? selectedColor))
                                .padding(.bottom, 0)
                            PantsShape(leftWidthRatio: leftWidthRatio, rightWidthRatio: rightWidthRatio)
                                .fill(uploadType == .top ? (selectedCompatibleColor ?? selectedColor) : selectedColor)
                                .frame(width: 70, height: 145)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Compatibility Palette
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Most compatible:")
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        HStack {
                            if let mostCompatible = mostCompatibleColor {
                                ColorBlocks(color: mostCompatible, isSelected: selectedCompatibleColor == mostCompatible)
                                    .onTapGesture {
                                        selectedCompatibleColor = mostCompatible
                                    }
                            }
                        }
                        
                        if !compatibleColors.isEmpty {
                            Text("Other compatible colors:")
                                .foregroundStyle(.black)
                            HStack(spacing: 16) {
                                ForEach(compatibleColors, id: \.self) { color in
                                    if color != mostCompatibleColor {
                                        ColorBlocks(color: color, isSelected: selectedCompatibleColor == color)
                                            .onTapGesture {
                                                selectedCompatibleColor = color
                                            }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
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
    }
    
    private func updateCompatibleColors() {
        let wardrobe = uploadType == .top ? colorManager.solidBottomColors : colorManager.solidTopColors
        
        // Get compatible colors using color theory
        compatibleColors = ColorTheoryManager.shared.getCompatibleColors(from: wardrobe, for: selectedColor)
        
        // Get most compatible color
        mostCompatibleColor = ColorTheoryManager.shared.getMostCompatibleColor(from: wardrobe, for: selectedColor)
        
        // Set initial selected compatible color
        selectedCompatibleColor = mostCompatibleColor
        
        print("Selected color: \(selectedColor)")
        print("Wardrobe colors: \(wardrobe)")
        print("Compatible colors: \(compatibleColors)")
        print("Most compatible: \(String(describing: mostCompatibleColor))")
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
}

#Preview {
    RecommendationView(selectedColor: .brown, uploadType: .top)
}
