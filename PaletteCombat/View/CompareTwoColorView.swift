//
//  CompareTwoColorView.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 22.01.2023.
//

import SwiftUI

struct CompareTwoColorView: View {

    @StateObject var leftColor = ComparableColor(.purple)
    @StateObject var rightColor = ComparableColor(.pink)
        
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundBlurView()
            VStack(alignment: .leading, spacing: 10) {
                colorCompareView()
                colorGradientView()
                colorInfoView()
                colorChangeView()
            }
            .padding()
        }
    }
    
    // MARK: - View builders
    @ViewBuilder
    func backgroundBlurView() -> some View {
        ZStack {
            Rectangle()
                .fill(distanceTintColor.opacity(0.15))
            Rectangle()
               .fill(Material.regularMaterial)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func colorCompareView() -> some View {
        let compareInfo = ColorCompareInfo(leftColor.color, rightColor.color)
        ProgressView(
            value: compareInfo.euclideanDistance,
            total: compareInfo.euclideanRangeMax
        ) {
            Text("Цветовое расстояние")
                .font(.title2)
            Text("для RGB в Евклидовом пространстве")
                .font(.caption2)
        } currentValueLabel: {
            Text("\(Int(compareInfo.euclideanDistance)) из \(Int(compareInfo.euclideanRangeMax))")
        }
        .tint(distanceTintColor)
        .fontWidth(.expanded)
    }

    @ViewBuilder
    func colorGradientView() -> some View {
        let colors = [
            leftColor.color,
            rightColor.color
        ]
        let gradient = LinearGradient(
            colors: colors,
            startPoint: .leading,
            endPoint: .trailing
        )
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(gradient)
        }
    }

    @ViewBuilder
    func colorInfoView() -> some View {
        VStack(spacing: 10) {
            Text("Есть такой же цвет, но с именем?")
            HStack {
                colorInformation(leftColor, .leading)
                Spacer()
                colorInformation(rightColor, .trailing)
            }
        }
        .fontWidth(.expanded)
    }
    
    @ViewBuilder
    func colorInformation(_ color: ComparableColor, _ alignment: HorizontalAlignment) -> some View {
        let info = color.colorInfo
        let hasPlaceholder = info == nil
        let hasName = info?.name.exactMatchName ?? false
        let closestColor: Color = Color(uiColor: UIColor(hex: info?.name.closestNamedHex ?? "") ?? .systemPink)
        
        VStack(alignment: alignment, spacing: 10) {
            VStack(alignment: alignment, spacing: 4) {
                Text(hasName ? "да, это": "нет, но ближайший")
                    .font(.caption)
                Text(info?.name.value ?? "[...]")
                    .font(.subheadline)
                Text(info?.name.closestNamedHex ?? "[#...]")
                    .font(.subheadline)

            }
            .redacted(reason: hasPlaceholder ? .placeholder : .privacy)

            VStack(spacing: 0) {
                Rectangle()
                    .fill(hasPlaceholder ? .gray.opacity(0.3) : closestColor)
                    .frame(maxHeight: .infinity)
                Rectangle()
                    .fill(color.color)
                    .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            Text("#\(color.color.hexString)")
                .font(.title2)
                .fontWidth(.expanded)
        }
        .fontWidth(.expanded)
    }
        
    @ViewBuilder
    func colorChangeView() -> some View {
        HStack {
            ColorPicker("", selection: $leftColor.color)
            ColorPicker("", selection: $rightColor.color)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
        }
    }
    
    var distanceTintColor: Color {
        let compareInfo = ColorCompareInfo(leftColor.color, rightColor.color)
        let max = compareInfo.euclideanRangeMax
        let current = compareInfo.euclideanDistance

        let percent = 1 / (max / current)
        let hue = 0.34 - percent / 3
        return Color(hue: hue, saturation: 1, brightness: 1)
    }
}

// MARK: - Preview
struct PaletteCombatView_Previews: PreviewProvider {
    static var previews: some View {
        CompareTwoColorView()
    }
}
