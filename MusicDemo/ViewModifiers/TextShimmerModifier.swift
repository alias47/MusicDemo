//
//  TextShimmerModifier.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct TextShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    let isActive: Bool

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay {
                    GeometryReader { geo in
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.15),
                                .white.opacity(0.85),
                                .white.opacity(0.45),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geo.size.width)
                        .offset(x: -geo.size.width + (geo.size.width * 2 * phase))
                    }
                }
                .mask(content)
                .onAppear {
                    phase = 0
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }
}
