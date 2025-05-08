//
//  ColorSuggestionView.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 08/05/25.
//
import SwiftUI

struct RecommendationView: View {
    @State private var topColor: Color = .brown
    @State private var bottomColor: Color = .teal
    @State private var selectedBottomIndex: Int = 0

    let bottomOptions: [Color] = [.teal, .black, .gray, .brown, .green]

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 6) {
                Text("Bottom Colors")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 12)
            }
            .padding(.horizontal)

            // Shirt and Pants Preview
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .shadow(radius: 2)
                    .frame(height: 220)
                
                VStack(spacing: 0) {
                    Image(systemName: "tshirt.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(topColor)

                    PantsShape()
                        .fill(bottomColor)
                        .frame(width: 60, height: 100)

                }
            }
            .padding(.horizontal)

            // Compatibility Palette
            VStack(alignment: .leading, spacing: 12) {
                Text("Most compatible:")
                    .fontWeight(.semibold)

                HStack {
                    ColorBlocks(color: bottomOptions.first ?? .clear, isSelected: selectedBottomIndex == 0)
                }

                Text("Compatible colors:")

                HStack(spacing: 16) {
                    ForEach(bottomOptions.indices.dropFirst(), id: \.self) { index in
                        ColorBlocks(color: bottomOptions[index], isSelected: selectedBottomIndex == index)
                            .onTapGesture {
                                bottomColor = bottomOptions[index]
                                selectedBottomIndex = index
                            }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .shadow(radius: 2)
            .padding(.horizontal)

            Spacer()

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
    }
}

struct ColorBlocks: View {
    var color: Color
    var isSelected: Bool

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 44, height: 44)
            .overlay(
                Circle()
                    .stroke(Color.black, lineWidth: isSelected ? 2 : 0)
            )
    }
}

struct PantsShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Celana dimulai dari kiri atas, ke bawah, ke tengah, dan naik lagi ke kanan atas
        path.move(to: CGPoint(x: 0, y: 0)) // kiri atas
        path.addLine(to: CGPoint(x: 0, y: height)) // kiri bawah
        path.addLine(to: CGPoint(x: width * 0.45, y: height)) // bawah bagian dalam kiri

        // Lekukan di tengah (area selangkangan)
        path.addQuadCurve(to: CGPoint(x: width * 0.55, y: height),
                          control: CGPoint(x: width * 0.48, y: height * 0.0))

        path.addLine(to: CGPoint(x: width, y: height)) // bawah bagian dalam kanan
        path.addLine(to: CGPoint(x: width, y: 0)) // kanan atas
        path.closeSubpath()

        return path
    }
}



#Preview {
    RecommendationView()
}



