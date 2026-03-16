//
//  GeneratingRowView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct GeneratingRowView: View {
    let title: String
    let progress: Int
    let status: String
    let showSkip: Bool
    let image: ImageResource
    let onSkip: () -> Void

    @State private var glowOffset: CGFloat = -10

    var body: some View {
        HStack(spacing: 16) {
            progressThumbnail

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .textShimmer(isActive: true)

                HStack(spacing: 4) {
                    Text(status)
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                        .lineLimit(1)
                        .animation(.easeInOut(duration: 0.2), value: status)

                    if showSkip {
                        Button(action: onSkip) {
                            Text("skip")
                                .underline()
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }

            Spacer(minLength: 0)

            versionBadge
        }
        .padding(.vertical, 8)
        .background(progressBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear {
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) {
                glowOffset = 10
            }
        }
    }

    private var progressFactor: CGFloat {
        CGFloat(max(0, min(progress, 100))) / 100
    }

    private var artworkOpacity: CGFloat {
        let value = CGFloat(progress)

        guard value >= 75 else { return 0 }
        let normalized = min((value - 75) / 25, 1)
        return normalized * normalized
    }

    private var glowOpacity: CGFloat {
        0.45 + (0.45 * progressFactor)
    }

    private var showsDot: Bool {
        progress >= 90
    }

    private var progressThumbnail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black)

            // Purple glow
            Circle()
                .fill(
                    Color(red: 170 / 255, green: 0, blue: 1)
                        .opacity(0.18 + glowOpacity * 0.75)
                )
                .frame(width: 68, height: 68)
                .blur(radius: 22)
                .offset(x: -10 + glowOffset, y: -2)

            // Orange glow
            Circle()
                .fill(
                    Color(red: 1, green: 98 / 255, blue: 0)
                        .opacity(0.12 + glowOpacity * 0.65)
                )
                .frame(width: 64, height: 64)
                .blur(radius: 20)
                .offset(x: 10 + glowOffset * 0.5, y: 16)

            // Inner color wash
            LinearGradient(
                colors: [
                    Color(red: 120 / 255, green: 30 / 255, blue: 140 / 255)
                        .opacity(0.15 + 0.20 * progressFactor),
                    Color.clear,
                    Color(red: 1, green: 98 / 255, blue: 0)
                        .opacity(0.08 + 0.12 * progressFactor),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

//            Image(.album)
            Image(image)
                .resizable()
                .scaledToFill()
                .opacity(artworkOpacity)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            if showsDot {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(6)
                    .transition(.opacity)
            }

            Text("\(progress)%")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(progress == 100 ? 0 : 0.65))
                .monospacedDigit()
                .animation(.easeInOut(duration: 0.2), value: progress)
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)

                if progress < 100 {
                    RotatingBorderView(
                        cornerRadius: 16,
                        lineWidth: 2,
                        glowLineWidth: 6,
                        duration: 2.2,
                        color: .gradientPink
                    )
                }
            }
        }
    }

    private var versionBadge: some View {
        Text("v1")
            .font(.system(size: 12))
            .foregroundStyle(.gray)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay {
                Capsule()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
    }

    private var progressBackground: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Color(white: 0.12)

                Color.gray.opacity(0.1)
                    .frame(width: geo.size.width * CGFloat(progress) / 100)
                    .animation(.linear(duration: 0.08), value: progress)
            }
        }
    }
}
