//
//  SongRowView.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 14/03/2026.
//

import SwiftUI

struct MusicGenarationTypeRow: View {
    let task: MusicTaskItem
    let onSkip: () -> Void

    var body: some View {
        switch task.state {
        case .generating:
            GeneratingRowView(
                title: task.title,
                progress: task.state.progressValue,
                status: task.state.statusText,
                showSkip: task.state.shouldShowSkip,
                onSkip: onSkip
            )

        case .completed:
            CompletedRowView(
                title: task.title,
                subtitle: task.subtitle,
                artwork: .album,
                showsStatusDot: false
            )
        case .new:
            CompletedRowView(
                title: task.title,
                subtitle: task.subtitle,
                artwork: .album
            )
        }
    }
}
