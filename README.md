Music App Demo – SwiftUI

This is a SwiftUI demo project that simulates AI music generation with a modern animated interface.

Features
- Animated song generation list
- Real-time progress updates
- Mini Player to Full Player transition
- Player expansion using MatchedGeometryEffect
- Glow thumbnail with rotating border animation
- Keyboard gradient glow effect
- Drag gestures for player interaction
- Mock AI generation simulation

UI Highlights
- Animated generating row
- Thumbnail glow effects
- Rotating progress border
- Floating Create prompt composer
- Mini Player
- Full screen media player

Tech Stack
- SwiftUI
- Combine
- Async/Await
- MatchedGeometryEffect
- Custom animations

Project Structure

Views
    DashboardScreen
    SongListScreen
    MiniPlayerView
    FullPlayerView
    GeneratingRowView

ViewModels
    SongListViewModel

Components
    RotatingThumbnailBorder
    AnimatedKeyboardGlow
    AppTextView

Interaction Flow
1. Tap Create
2. Enter a prompt
3. A generation task appears in the list
4. Progress updates simulate AI processing
5. Tap a song to open the Mini Player
6. Tap or drag up to open the Full Player

Notes
This project focuses on UI animation and interaction patterns.  
It does not implement real music generation.
