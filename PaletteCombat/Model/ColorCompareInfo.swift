//
//  ColorCompareInfo.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 25.01.2023.
//

import SwiftUI

class ColorCompareInfo {
    init(_ leftColor: Color, _ rightColor: Color) {
        self.leftColor = UIColor(leftColor)
        self.rightColor = UIColor(rightColor)
    }
    
    let leftColor: UIColor
    let rightColor: UIColor
    
    // MARK: - Computable properties
    
    /// This variable returns the distance between two `Color` in Euclidean space
    ///
    /// - Returns: The distance between the two RGB colors in Euclidean space.
    /// ```
    /// let distance = ColorCompareInfo(.blue, .cyan).euclideanDistance
    /// print("\(distance)") // "29.746"
    /// ```
    ///
    var euclideanDistance: CGFloat {
        let lRGB = (leftColor.rgba.red, leftColor.rgba.green, leftColor.rgba.blue)
        let rRGB = (rightColor.rgba.red, rightColor.rgba.green, rightColor.rgba.blue)

        return euclideanDistance(lRGB, rRGB)
    }
    
    #warning("var euclideanRangeMax // Document needed")
    var euclideanRangeMax: CGFloat {
        return euclideanDistance((0,0,0), (1,1,1))
    }
    
    // MARK: - Private
    #warning("func euclideanDistance // Document needed")
    private func euclideanDistance(
        _ lRGB: (red: CGFloat, green: CGFloat, blue: CGFloat),
        _ rRGB: (red: CGFloat, green: CGFloat, blue: CGFloat)
    ) -> CGFloat {
        
        let powRed   = pow((lRGB.red * 255 - rRGB.red * 255),2)
        let powGreen = pow((lRGB.green * 255 - rRGB.green * 255),2)
        let powBlue  = pow((lRGB.blue * 255 - rRGB.blue * 255),2)

        let sum = powRed + powGreen + powBlue
        return sum.squareRoot().rounded()
    }
}
