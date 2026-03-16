//
//  SongListScreen.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//
import SwiftUI

struct SongListScreen: View {
    @ObservedObject var viewModel: SongListViewModel

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
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectTask(task)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    // MARK: Header view
    private var headerView: some View {
        HStack(spacing: 10) {
            Image(.logo)
                .resizable()
                .frame(width: 36, height: 36)

            Text("MusicGPT")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    SongListScreen(viewModel: .init())
}
