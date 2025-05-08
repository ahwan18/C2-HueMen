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
    
    // Add parameters for selected color and upload type
    let selectedColor: Color
    let uploadType: UploadType
    
    // Sekarang, gunakan mode .top
    var mode: Mode = .top
    
    @State private var topColor: Color = .brown
    @State private var bottomColor: Color = .teal
    @State private var selectedBottomIndex: Int = 0
    @State private var selectedTopIndex: Int = 0
    
    // Developer dapat mengubah nilai default di sini:
    @State private var leftWidthRatio: CGFloat = -0.020
    @State private var rightWidthRatio: CGFloat = 1
    
    let bottomOptions: [Color] = [.teal, .black, .gray, .brown, .green]
    let topOptions: [Color] = [.brown, .white, .black, .gray, .blue]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Text(mode == .top ? SectionTitle.bottom.rawValue : SectionTitle.top.rawValue)
                        .foregroundStyle(.black)
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer().frame(height: 12)
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
                            .foregroundColor(topColor)
                            .padding(.bottom, 0)
                        PantsShape(leftWidthRatio: leftWidthRatio, rightWidthRatio: rightWidthRatio)
                            .fill(bottomColor)
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
                        if mode == .top {
                            ColorBlocks(color: bottomOptions.first ?? .clear, isSelected: selectedBottomIndex == 0)
                                .onTapGesture {
                                    bottomColor = bottomOptions.first ?? .clear
                                    selectedBottomIndex = 0
                                }
                        } else {
                            ColorBlocks(color: topOptions.first ?? .clear, isSelected: selectedTopIndex == 0)
                                .onTapGesture {
                                    topColor = topOptions.first ?? .clear
                                    selectedTopIndex = 0
                                }
                        }
                    }
                    Text("Compatible colors:")
                        .foregroundStyle(.black)
                    HStack(spacing: 16) {
                        if mode == .top {
                            CompatibleBottomColorsView(
                                bottomOptions: bottomOptions,
                                selectedBottomIndex: $selectedBottomIndex,
                                bottomColor: $bottomColor
                            )
                        } else {
                            CompatibleTopColorsView(
                                topOptions: topOptions,
                                selectedTopIndex: $selectedTopIndex,
                                topColor: $topColor
                            )
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
                    // Action here
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top)
            .preferredColorScheme(.light)
            .onAppear {
                // Set the initial color based on uploadType
                if uploadType == .top {
                    topColor = selectedColor
                } else {
                    bottomColor = selectedColor
                }
            }
        }
    }
    
    struct ColorBlocks: View {
        var color: Color
        var isSelected: Bool
        
        var body: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 70, height: 55)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
    }
    
    struct CompatibleBottomColorsView: View {
        let bottomOptions: [Color]
        @Binding var selectedBottomIndex: Int
        @Binding var bottomColor: Color
        
        var body: some View {
            ForEach(Array(bottomOptions.indices.dropFirst()), id: \.self) { index in
                ColorBlocks(color: bottomOptions[index], isSelected: selectedBottomIndex == index)
                    .onTapGesture {
                        bottomColor = bottomOptions[index]
                        selectedBottomIndex = index
                    }
            }
        }
    }
    
    struct CompatibleTopColorsView: View {
        let topOptions: [Color]
        @Binding var selectedTopIndex: Int
        @Binding var topColor: Color
        
        var body: some View {
            ForEach(Array(topOptions.indices.dropFirst()), id: \.self) { index in
                ColorBlocks(color: topOptions[index], isSelected: selectedTopIndex == index)
                    .onTapGesture {
                        topColor = topOptions[index]
                        selectedTopIndex = index
                    }
            }
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
