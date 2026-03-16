//
//  CompletedRowView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct CompletedRowView: View {
    let title: String
    let subtitle: String
    let artwork: ImageResource
    var showsStatusDot: Bool = true

    var body: some View {
        HStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                Image(artwork)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                if showsStatusDot {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .overlay {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        }
                        .padding(5)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }

            Spacer()

            Button {
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.gray)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}
