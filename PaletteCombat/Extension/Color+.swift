//
//  Color+.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 25.01.2023.
//

import SwiftUI

extension Color {
    
    /// This variable takes a Color and turns it into a hex string.
    /// ```
    /// Color.red.hexString // "FF3B30"
    /// ```
    ///
    /// - Parameter Color: The color to turn into a hex string.
    /// - Returns: String description color in HEX format.
    ///
    var hexString: String {
        let uic = UIColor(self)
        return uic.hexString
    }
}
