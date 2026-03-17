//
//  AnimateKeyboardGlowView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 17/03/2026.
//

import SwiftUI

struct AnimatedKeyboardGlow: View {
    var colors: [Color] = [
        Color(hex: "BC82F3"),
        Color(hex: "F5B9EA"),
        Color(hex: "8D9FFF"),
        Color(hex: "FF6778"),
        Color(hex: "FFBA71"),
        Color(hex: "C686FF"),
    ]

    var animationDuration: Double = 2.5

    @State private var angle: Double = 0

    var body: some View {
        ZStack {
            glowLayer(height: 400, blur: 36, opacity: 1)
            glowLayer(height: 400, blur: 46, opacity: 1)
            glowLayer(height: 400, blur: 56, opacity: 1)
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                angle = 360
            }
        }
    }

    @ViewBuilder
    private func glowLayer(height: CGFloat, blur: CGFloat, opacity: Double) -> some View {
        Rectangle()
            .fill(
                AngularGradient(
                    gradient: Gradient(colors: colors),
                    center: .center,
                    startAngle: .degrees(angle),
                    endAngle: .degrees(angle + 360)
                )
            )
            .frame(height: height)
            .blur(radius: blur)
            .mask(
                LinearGradient(
                    colors: [.clear, .white, .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
}
