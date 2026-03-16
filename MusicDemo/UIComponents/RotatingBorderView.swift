//
//  RotatingBorder.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 16/03/2026.
//

import SwiftUI

struct RotatingBorderView: View {
    var cornerRadius: CGFloat = 16
    var lineWidth: CGFloat = 2
    var glowLineWidth: CGFloat = 6
    var duration: Double = 2.2
    var color: Color = .gradientPink

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let progress = (time.truncatingRemainder(dividingBy: duration)) / duration
            let angle = progress * 360

            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0.00),
                                .init(color: .clear, location: 0.38),
                                .init(color: color.opacity(0.25), location: 0.46),
                                .init(color: color.opacity(0.85), location: 0.50),
                                .init(color: color.opacity(0.25), location: 0.54),
                                .init(color: .clear, location: 0.62),
                                .init(color: .clear, location: 1.00),
                            ]),
                            center: .center,
                            startAngle: .degrees(angle),
                            endAngle: .degrees(angle + 360)
                        ),
                        lineWidth: lineWidth
                    )

                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(stops: [
                                .init(color: .clear, location: 0.00),
                                .init(color: .clear, location: 0.38),
                                .init(color: color.opacity(0.18), location: 0.46),
                                .init(color: color.opacity(0.50), location: 0.50),
                                .init(color: color.opacity(0.18), location: 0.54),
                                .init(color: .clear, location: 0.62),
                                .init(color: .clear, location: 1.00),
                            ]),
                            center: .center,
                            startAngle: .degrees(angle),
                            endAngle: .degrees(angle + 360)
                        ),
                        lineWidth: glowLineWidth
                    )
                    .blur(radius: 5)
            }
        }
        .allowsHitTesting(false)
        .drawingGroup()
    }
}
