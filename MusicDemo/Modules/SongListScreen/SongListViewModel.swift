//
//  SongListViewModel.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

enum MusicTaskState: Equatable {
    case generating(progress: Int, status: String, showSkip: Bool)
    case completed
    case new

    var progressValue: Int {
        switch self {
        case let .generating(progress, _, _):
            return progress
        case .completed, .new:
            return 100
        }
    }

    var statusText: String {
        switch self {
        case let .generating(progress, status, _):
            if !status.isEmpty {
                return status
            }

            switch progress {
            case 0...30: return "Analyzing prompt..."
            case 31...70: return "Composing melody..."
            case 71...99: return "Finalizing track..."
            default: return "Downloading assets..."
            }

        case .completed, .new:
            return "Completed"
        }
    }

    var shouldShowSkip: Bool {
        switch self {
        case let .generating(_, _, showSkip):
            return showSkip
        case .completed, .new:
            return false
        }
    }

    var isGenerating: Bool {
        if case .generating = self {
            return true
        }
        return false
    }
}

@MainActor
final class SongListViewModel: ObservableObject {
    @Published private(set) var tasks: [MusicTaskItem] = []
    @Published var selectedTask: MusicTaskItem?

    private var runningTasks: [UUID: Task<Void, Never>] = [:]

    init() {
        loadMockData()
    }

    deinit {
        runningTasks.values.forEach { $0.cancel() }
    }

    func selectTask(_ task: MusicTaskItem) {
        selectedTask = task
    }

    func startNewGeneration(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let newTask = MusicTaskItem(
            title: trimmedTitle,
            subtitle: "",
            state: .generating(
                progress: 0,
                status: "Starting AI audio engine",
                showSkip: false
            ),
            imageColor: .clear
        )

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            tasks.insert(newTask, at: 0)
        }

        simulateGeneration(for: newTask.id)
    }

    func cancelTask(id: UUID) {
        runningTasks[id]?.cancel()
        runningTasks[id] = nil

        if selectedTask?.id == id {
            selectedTask = nil
        }

        withAnimation(.easeInOut) {
            tasks.removeAll { $0.id == id }
        }
    }

    private func updateTask(
        id: UUID,
        _ update: (inout MusicTaskItem) -> Void
    ) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        update(&tasks[index])

        if selectedTask?.id == id {
            selectedTask = tasks[index]
        }
    }
    private func simulateGeneration(for id: UUID) {
        runningTasks[id]?.cancel()

        let task = Task { [weak self] in
            guard let self else { return }

            do {
                try await Task.sleep(nanoseconds: 1_500_000_000)
                try Task.checkCancellation()

                self.updateTask(id: id) { task in
                    task.state = .generating(
                        progress: 0,
                        status: "21.4K users in queue",
                        showSkip: true
                    )
                }

                try await Task.sleep(nanoseconds: 1_000_000_000)
                try Task.checkCancellation()

                for progress in 1...100 {
                    try await Task.sleep(nanoseconds: 40_000_000)
                    try Task.checkCancellation()

                    self.updateTask(id: id) { task in
                        let status: String
                        switch progress {
                        case 0...30:
                            status = "Analyzing prompt..."
                        case 31...70:
                            status = "Composing melody..."
                        case 71...99:
                            status = "Finalizing track..."
                        default:
                            status = "Downloading assets..."
                        }

                        task.state = .generating(
                            progress: progress,
                            status: status,
                            showSkip: true
                        )
                    }
                }

                await MainActor.run {
                    if let index = self.tasks.firstIndex(where: { $0.id == id }) {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true

                        withTransaction(transaction) {
                            self.tasks[index].state = .new
                            self.tasks[index].subtitle = "Funky house song generated successfully"
                            self.tasks[index].imageColor = .pink
                        }
                    }
                }
                Haptic.notify(.success)
                self.runningTasks[id] = nil
            } catch {
                self.runningTasks[id] = nil
            }
        }

        runningTasks[id] = task
    }

    private func loadMockData() {
        tasks = [
            MusicTaskItem(
                title: "Language Training",
                subtitle: "Create a presentation that explains how lan...",
                state: .completed,
                imageColor: .white
            ),
            MusicTaskItem(
                title: "Bam Bam",
                subtitle: "Generate a script for a play about the powe...",
                state: .completed,
                imageColor: .gray
            ),
            MusicTaskItem(
                title: "Enemy",
                subtitle: "Compose a poem about the meaning...",
                state: .completed,
                imageColor: .blue
            ),
            MusicTaskItem(
                title: "Balenciaga",
                subtitle: "Generate a poem about a los...",
                state: .completed,
                imageColor: .purple
            )
        ]
    }
}
