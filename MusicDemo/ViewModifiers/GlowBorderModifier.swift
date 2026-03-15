//
//  GlowBorderModifier.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 15/03/2026.
//

import SwiftUI

struct GlowBorderModifier: ViewModifier {
    var isActive: Bool
    var cornerRadius: CGFloat = 18
    var padding: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    AnimatedGlowBorder(cornerRadius: cornerRadius)
                        .padding(-padding)
                }
            }
    }
}
