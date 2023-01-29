//
//  ComparableColor.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 26.01.2023.
//

import Combine
import Foundation
import SwiftUI

class ComparableColor: ObservableObject {
    init(_ color: Color) {
        self.color = color
        initSubscribers()
        hexString = color.hexString
    }

    private let colorApiService = ColorApiProvider()
    private var cancellables = Set<AnyCancellable>()

    public var color: Color {
        didSet {
            colorInfo = nil
            hexString = color.hexString
        }
    }

    @Published var hexString: String = ""
    @Published var colorInfo: ColorApiResponse?

    private func initSubscribers() {
        $hexString
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] hex in
                self?.getColorInfo(by: hex)
            })
            .store(in: &cancellables)
    }

    private func getColorInfo(by hex: String) {
        guard hex != "" else { return }
        colorApiService.colorInfo(hex: hex)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] colorApiInfo in
                self?.colorInfo = colorApiInfo
            })
            .store(in: &cancellables)
    }
}
