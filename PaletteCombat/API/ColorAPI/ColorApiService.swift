//
//  ColorApiService.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 25.01.2023.
//

import Foundation
import Combine

/// - Note: [The Color API Docs](https://www.thecolorapi.com/docs)
protocol ColorApiService {
    
    /// Return available identifying information on the given color.
    ///
    /// - Parameters:
    ///   - hex: Valid hex code
    ///   - rgb: Valid rgb color, also rgb(0,71,171)
    ///   - hsl: Valid hsl color, also hsl(215,100%,34%)
    ///   - cmyk: Valid cmyk color, also cmyk(100,58,0,33)
    ///   - format: Return results as JSON, SVG or HTML page
    ///   - w: Height of resulting image, only applicable on SVG format
    ///   - named: Whether to print the color names on resulting image, only applicable on SVG format
    /// - Returns: Available identifying information on the given color.
    /// - Warning: Don't do it (sorry, it's a joke)
    ///
    func colorInfo(
        hex: String?,
        rgb: String?,
        hsl: String?,
        cmyk: String?,
        format: ColorApiResponseFormat?,
        w: Int?,
        named: Bool?
    ) -> AnyPublisher<ColorApiResponse?, Never>
}

