//
//  ColorApiResponse.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 26.01.2023.
//

import Foundation

struct ColorApiResponse: Codable {
    let rgb: RGB
    let hex: Hex
    let name: Name
    
    struct RGB: Codable {
        let fraction: RGBFraction
        let r, g, b: Int
        let value: String
        
        struct RGBFraction: Codable {
            let r, g, b: Double
        }
    }
    
    struct Hex: Codable {
        let value, clean: String
    }

    struct Name: Codable {
        let value, closestNamedHex: String
        let exactMatchName: Bool
        let distance: Int

        enum CodingKeys: String, CodingKey {
            case value
            case closestNamedHex = "closest_named_hex"
            case exactMatchName = "exact_match_name"
            case distance
        }
    }
}
