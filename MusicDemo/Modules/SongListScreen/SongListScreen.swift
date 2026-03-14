//
//  SongListScreen.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//
import SwiftUI

struct SongListScreen: View {
    @StateObject private var viewModel = SongListViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                headerView

                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.tasks) { task in
                            MusicGenarationTypeRow(
                                task: task,
                                onSkip: {
                                    viewModel.cancelTask(id: task.id)
                                }
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
            }
        }
    }

    private var headerView: some View {
        HStack(spacing: 10) {
            Image(.logo)
                .resizable()
                .frame(width: 36, height: 36)

            Text("Songs")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Spacer()

            Button(action: viewModel.startNewGeneration) {
                Text("Start Generation")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white, in: Capsule())
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    SongListScreen()
}
