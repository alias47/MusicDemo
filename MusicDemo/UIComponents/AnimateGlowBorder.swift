//
//  AnimateGlowBorder.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 15/03/2026.
//

import SwiftUI

struct AnimatedGlowBorder: View {
    var cornerRadius: CGFloat = 18
    var lineWidths: [CGFloat] = [2, 4, 8, 14]
    var blurRadii: [CGFloat] = [0, 4, 10, 18]
    var animationDuration: Double = 2.2
    var colors: [Color] = [
        Color(hex: "FF9A5A"),
        Color(hex: "FF5DB1"),
        Color(hex: "BC82F3"),
        Color(hex: "FF9A5A"),
    ]

    @State private var startAngle: Double = 0
    @State private var endAngle: Double = 360

    var body: some View {
        ZStack {
            ForEach(Array(lineWidths.indices), id: \.self) { index in
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: colors),
                            center: .center,
                            startAngle: .degrees(startAngle),
                            endAngle: .degrees(endAngle)
                        ),
                        lineWidth: lineWidths[index]
                    )
                    .blur(radius: blurRadii[index])
                    .opacity(opacity(for: index))
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                startAngle = 360
                endAngle = 720
            }
        }
    }

    private func opacity(for index: Int) -> Double {
        switch index {
        case 0: return 1.0
        case 1: return 0.9
        case 2: return 0.55
        default: return 0.3
        }
    }
}

// MARK: Shape

struct ShapeGlow<S: Shape>: View {
    let shape: S
    var colors: [Color] = [
        Color(hex: "FF9A5A"),
        Color(hex: "FF5DB1"),
        Color(hex: "BC82F3"),
        Color(hex: "FF9A5A"),
    ]

    @State private var angle: Double = 0

    var body: some View {
        ZStack {
            shape
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(angle),
                        endAngle: .degrees(angle + 360)
                    ),
                    lineWidth: 2
                )

            shape
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(angle),
                        endAngle: .degrees(angle + 360)
                    ),
                    lineWidth: 6
                )
                .blur(radius: 6)
                .opacity(0.7)

            shape
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: colors),
                        center: .center,
                        startAngle: .degrees(angle),
                        endAngle: .degrees(angle + 360)
                    ),
                    lineWidth: 12
                )
                .blur(radius: 14)
                .opacity(0.35)
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                angle = 360
            }
        }
    }
}

struct GlowTextFieldDemo: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            TextField("Type something...", text: $text)
                .focused($isFocused)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.black.opacity(0.85))
                )
                .animatedGlow(
                    isActive: isFocused,
                    cornerRadius: 18,
                    padding: 6
                )
                .padding(.horizontal, 20)
        }
        .preferredColorScheme(.dark)
        .padding()
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    GlowTextFieldDemo()
}
