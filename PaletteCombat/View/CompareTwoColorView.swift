//
//  CompareTwoColorView.swift
//  PaletteCombat
//
//  Created by Глеб Столярчук on 22.01.2023.
//

import SwiftUI

struct CompareTwoColorView: View {
    @StateObject var leftColor = ComparableColor(.cyan)
    @StateObject var rightColor = ComparableColor(.blue)
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                backgroundBlurView()
                VStack(alignment: .leading, spacing: 10) {
                    colorInfoView()
                    colorCompareView()
                    colorGradientView()
                }
                .padding()
            }
            barView()
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
    
    // MARK: - View builders
    @ViewBuilder
    func backgroundBlurView() -> some View {
        ZStack {
            Rectangle()
                .fill(.white.opacity(0.1))
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
                .font(.subheadline)
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
            // UP
            VStack(alignment: alignment, spacing: 4) {
                Text(hasName ? "да, это": "нет, но ближайший")
                    .font(.caption)
                Text(info?.name.value ?? "[...]")
                    .font(.subheadline)
            }
            .redacted(reason: hasPlaceholder ? .placeholder : .privacy)

            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(hasPlaceholder ? .gray.opacity(0.3) : closestColor)
                        .frame(maxHeight: .infinity)
                    
                    Text(info?.name.closestNamedHex ?? "#000000")
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .background {
                            Rectangle()
                                .fill(.regularMaterial)
                        }
                        .redacted(reason: hasPlaceholder ? .placeholder : .privacy)
                }
                
                // DOWN
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(color.color)
                        .frame(maxHeight: .infinity)
                    
                    Text("#\(color.color.hexString)")
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .background {
                            Rectangle()
                                .fill(.regularMaterial)
                        }
                }
            }
            .fontWidth(.expanded)
            .font(.subheadline)
            .frame(maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
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
        .frame(maxWidth: 100)
    }
    
    @ViewBuilder
    func barView() -> some View {
        HStack(spacing: 30) {
//            // Info
//            Button {
//                print("action")
//            } label: {
//                Image(systemName: "questionmark.circle.fill")
//                    .tint(.black)
//                    .padding(8)
//                    .background {
//                        RoundedRectangle(cornerRadius: 4, style: .continuous)
//                            .fill(distanceTintColor)
//                    }
//            }
            HStack {
                ColorPicker("", selection: $leftColor.color)
                ColorPicker("", selection: $rightColor.color)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
            }
            .frame(maxWidth: 100)
//
//            // Share
//            Button {
//                print("action")
//            } label: {
//                Image(systemName: "square.and.arrow.up.fill")
//                    .tint(.black)
//                    .padding(8)
//                    .background {
//                        RoundedRectangle(cornerRadius: 4, style: .continuous)
//                            .fill(distanceTintColor)
//                    }
//            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thickMaterial)
    }
}

// MARK: - Preview
struct PaletteCombatView_Previews: PreviewProvider {
    static var previews: some View {
        CompareTwoColorView()
    }
}
