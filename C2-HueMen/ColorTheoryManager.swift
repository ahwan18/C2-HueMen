import SwiftUI

class ColorTheoryManager {
    static let shared = ColorTheoryManager()
    
    private init() {}
    
    // MARK: - Color Theory Calculations
    
    /// Calculate complementary color (180 degrees opposite)
    func getComplementaryColor(hue: CGFloat) -> CGFloat {
        return (hue + 180).truncatingRemainder(dividingBy: 360)
    }
    
    /// Calculate triadic colors (120 degrees apart)
    func getTriadicColors(hue: CGFloat) -> [CGFloat] {
        let color1 = (hue + 120).truncatingRemainder(dividingBy: 360)
        let color2 = (hue + 240).truncatingRemainder(dividingBy: 360)
        return [color1, color2]
    }
    
    /// Calculate split complementary colors (150 degrees on each side of complementary)
    func getSplitComplementaryColors(hue: CGFloat) -> [CGFloat] {
        let complementary = getComplementaryColor(hue: hue)
        let color1 = (complementary + 30).truncatingRemainder(dividingBy: 360)
        let color2 = (complementary - 30).truncatingRemainder(dividingBy: 360)
        return [color1, color2]
    }
    
    /// Calculate analogous colors (30 degrees on each side)
    func getAnalogousColors(hue: CGFloat) -> [CGFloat] {
        let color1 = (hue + 30).truncatingRemainder(dividingBy: 360)
        let color2 = (hue - 30).truncatingRemainder(dividingBy: 360)
        return [color1, color2]
    }
    
    /// Calculate tetradic colors (90 degrees apart)
    func getTetradicColors(hue: CGFloat) -> [CGFloat] {
        let color1 = (hue + 90).truncatingRemainder(dividingBy: 360)
        let color2 = (hue + 180).truncatingRemainder(dividingBy: 360)
        let color3 = (hue + 270).truncatingRemainder(dividingBy: 360)
        return [color1, color2, color3]
    }
    
    func isMonochromatic(hue1: CGFloat, hue2: CGFloat, tolerance: CGFloat = 5) -> Bool {
        let diff = abs(hue1 - hue2)
        return diff <= tolerance || diff >= (360 - tolerance)
    }
    
    func isNeutralColor(saturation: CGFloat, brightness: CGFloat) -> Bool {
        return saturation <= 0.15 || brightness <= 0.15 || brightness >= 0.85
    }
    
    func isTrulyNeutral(color: UIColor) -> Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Cek jika warnanya sangat mendekati putih atau hitam
        let isWhite = red > 0.95 && green > 0.95 && blue > 0.95
        let isBlack = red < 0.05 && green < 0.05 && blue < 0.05
        
        return isWhite || isBlack
    }
    
    
    
    // MARK: - Color Compatibility
    
    /// Check if two colors are compatible within a tolerance range
    func isColorCompatible(hue1: CGFloat, hue2: CGFloat, tolerance: CGFloat = 10) -> Bool {
        let difference = abs(hue1 - hue2)
        return difference <= tolerance || difference >= (360 - tolerance)
    }
    
//        /// Get compatible colors from a wardrobe based on color theory
//        func getCompatibleColors(from wardrobe: [Color], for baseColor: Color, tolerance: CGFloat = 10) -> [Color] {
//            guard let baseHSB = UIColor(baseColor).toHSB() else { return [] }
//    
//            // Get all possible compatible hues based on color theory
//            var compatibleHues: Set<CGFloat> = []
//    
//            // Add complementary
//            compatibleHues.insert(getComplementaryColor(hue: baseHSB.hue))
//    
//            // Add triadic
//            compatibleHues.formUnion(getTriadicColors(hue: baseHSB.hue))
//    
//            // Add split complementary
//            compatibleHues.formUnion(getSplitComplementaryColors(hue: baseHSB.hue))
//    
//            // Add analogous
//            compatibleHues.formUnion(getAnalogousColors(hue: baseHSB.hue))
//    
//            // Filter wardrobe colors based on compatibility
//            return wardrobe.filter { color in
//                guard let hsb = UIColor(color).toHSB() else { return false }
//    
//                // Check if the hue is within tolerance of any compatible hue
//                return compatibleHues.contains { compatibleHue in
//                    isColorCompatible(hue1: hsb.hue, hue2: compatibleHue, tolerance: tolerance)
//                }
//            }
//        }
    
    func getCompatibleColors(from wardrobe: [Color], for baseColor: Color, tolerance: CGFloat = 10) -> [Color] {
        guard let baseHSB = UIColor(baseColor).toHSB() else { return [] }

        var compatibleHues: Set<CGFloat> = []
        compatibleHues.insert(getComplementaryColor(hue: baseHSB.hue))
        compatibleHues.formUnion(getTriadicColors(hue: baseHSB.hue))
        compatibleHues.formUnion(getSplitComplementaryColors(hue: baseHSB.hue))
        compatibleHues.formUnion(getAnalogousColors(hue: baseHSB.hue))
        compatibleHues.formUnion(getTetradicColors(hue: baseHSB.hue))

        return wardrobe.filter { color in
            guard let hsb = UIColor(color).toHSB() else { return false }
            let uiColor = UIColor(color)

            // Warna netral selalu cocok
            if isTrulyNeutral(color: uiColor) || isNeutralColor(saturation: hsb.saturation, brightness: hsb.brightness) {
                return true
            }

            // Warna monochromatic (hue sangat dekat)
            if isMonochromatic(hue1: hsb.hue, hue2: baseHSB.hue) {
                return true
            }

            // Cek apakah hue termasuk dalam harmoni warna
            return compatibleHues.contains { targetHue in
                isColorCompatible(hue1: hsb.hue, hue2: targetHue, tolerance: tolerance)
            }
        }
    }

    
    
//        /// Get the most compatible color from a wardrobe based on color theory
//        func getMostCompatibleColor(from wardrobe: [Color], for baseColor: Color) -> Color? {
//            guard let baseHSB = UIColor(baseColor).toHSB() else { return nil }
//    
//            // Get complementary color as the most compatible
//            let complementaryHue = getComplementaryColor(hue: baseHSB.hue)
//    
//            // Find the color in wardrobe closest to complementary
//            return wardrobe.min { color1, color2 in
//                guard let hsb1 = UIColor(color1).toHSB(),
//                      let hsb2 = UIColor(color2).toHSB() else {
//                    return false
//                }
//    
//                let diff1 = abs(hsb1.hue - complementaryHue)
//                let diff2 = abs(hsb2.hue - complementaryHue)
//    
//                return min(diff1, 360 - diff1) < min(diff2, 360 - diff2)
//            }
//        }
    
//    Get the most compatible color from a wardrobe based on all major color harmony rules
    func getMostCompatibleColor(from wardrobe: [Color], for baseColor: Color) -> Color? {
        // Dapatkan warna-warna yang sudah lolos dari teori harmonisasi
        let compatibleColors = getCompatibleColors(from: wardrobe, for: baseColor)
        
        guard let baseHSB = UIColor(baseColor).toHSB() else { return nil }
        let complementaryHue = getComplementaryColor(hue: baseHSB.hue)
        
        // Dari warna yang lolos saja, cari yang paling dekat ke complementary hue
        return compatibleColors.min { color1, color2 in
            guard let hsb1 = UIColor(color1).toHSB(),
                  let hsb2 = UIColor(color2).toHSB() else { return false }
            
            let diff1 = min(abs(hsb1.hue - complementaryHue), 360 - abs(hsb1.hue - complementaryHue))
            let diff2 = min(abs(hsb2.hue - complementaryHue), 360 - abs(hsb2.hue - complementaryHue))
            
            return diff1 < diff2
        }
    }


    
}



