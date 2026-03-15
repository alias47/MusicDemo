//
//  MusicTaskItem.swift
//  MusicDemo
//
//  Created by Atit Kayastha on 15/03/2026.
//

import SwiftUI

struct MusicTaskItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var subtitle: String
    var state: MusicTaskState
    var imageColor: Color

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        state: MusicTaskState,
        imageColor: Color
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.state = state
        self.imageColor = imageColor
    }
}
