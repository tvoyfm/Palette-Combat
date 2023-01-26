//
//  ColorApiProvider.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 26.01.2023.
//

import Foundation
import Combine

class ColorApiProvider: ColorApiService {
    func colorInfo(
        hex: String?,
        rgb: String? = nil,
        hsl: String? = nil,
        cmyk: String? = nil,
        format: ColorApiResponseFormat? = .json,
        w: Int? = nil,
        named: Bool? = nil
    ) -> AnyPublisher<ColorApiResponse?, Never> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.thecolorapi.com"
        components.path = "/id"

        let queryItems: [URLQueryItem] = {
            var items: [URLQueryItem] = []
            if let hex = hex { items.append(URLQueryItem(name: "hex", value: hex)) }
            if let rgb = rgb { items.append(URLQueryItem(name: "rgb", value: rgb)) }
            if let hsl = hsl { items.append(URLQueryItem(name: "hsl", value: hsl)) }
            if let cmyk = cmyk { items.append(URLQueryItem(name: "cmyk", value: cmyk)) }
            if let format = format { items.append(URLQueryItem(name: "format", value: format.rawValue)) }
            if let named = named { items.append(URLQueryItem(name: "named", value: named.description)) }
            return items
        }()
        
        components.queryItems = queryItems
        
        guard let url = components.url else { return Just(nil).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ColorApiResponse?.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { response in
                //print(response?.name.value ?? "EMPTY RESPONSE")
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
