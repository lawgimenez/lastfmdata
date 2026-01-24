//
//  TopAlbumsView.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

private enum GridLayout: String, CaseIterable, Identifiable {
    case horizontal = "2x8"
    case twoByTwo = "2x2"
    
    var id: String { rawValue }
}

private enum PosterTheme: String, CaseIterable, Identifiable {
    case midnight = "Midnight"
    case sunset = "Sunset"
    case ocean = "Ocean"
    case forest = "Forest"
    case sand = "Sand"
    
    var id: String { rawValue }
    
    var background: LinearGradient {
        switch self {
        case .midnight:
            return LinearGradient(
                colors: [
                    Color(.sRGB, red: 0.07, green: 0.08, blue: 0.14, opacity: 1),
                    Color(.sRGB, red: 0.13, green: 0.15, blue: 0.25, opacity: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sunset:
            return LinearGradient(
                colors: [
                    Color(.sRGB, red: 1.00, green: 0.54, blue: 0.29, opacity: 1),
                    Color(.sRGB, red: 0.92, green: 0.24, blue: 0.42, opacity: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ocean:
            return LinearGradient(
                colors: [
                    Color(.sRGB, red: 0.09, green: 0.45, blue: 0.72, opacity: 1),
                    Color(.sRGB, red: 0.10, green: 0.72, blue: 0.73, opacity: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .forest:
            return LinearGradient(
                colors: [
                    Color(.sRGB, red: 0.10, green: 0.36, blue: 0.23, opacity: 1),
                    Color(.sRGB, red: 0.16, green: 0.54, blue: 0.28, opacity: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sand:
            return LinearGradient(
                colors: [
                    Color(.sRGB, red: 0.93, green: 0.84, blue: 0.72, opacity: 1),
                    Color(.sRGB, red: 0.87, green: 0.73, blue: 0.53, opacity: 1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var titleColor: Color {
        switch self {
        case .sand:
            return Color(.sRGB, red: 0.26, green: 0.19, blue: 0.12, opacity: 1)
        default:
            return Color.white
        }
    }
    
    var titleShadow: Color {
        switch self {
        case .sand:
            return Color.black.opacity(0.15)
        default:
            return Color.black.opacity(0.35)
        }
    }
    
    var placeholder: Color {
        switch self {
        case .sand:
            return Color(.sRGB, red: 0.82, green: 0.70, blue: 0.55, opacity: 0.7)
        default:
            return Color.white.opacity(0.18)
        }
    }
}

private struct TopAlbumsPoster: View {
    let albums: [TopAlbums.Album]
    let gridLayout: GridLayout
    let theme: PosterTheme
    
    private let rows = [
        GridItem(.fixed(300), spacing: 10),
        GridItem(.fixed(300)),
    ]
    
    private let twoByTwoColumns = [
        GridItem(.flexible(minimum: 200), spacing: 10),
        GridItem(.flexible(minimum: 200)),
    ]
    
    var body: some View {
        let displayAlbums = gridLayout == .twoByTwo ? Array(albums.prefix(4)) : albums
        VStack(spacing: 16) {
            Text("Your Last.fm Top Albums")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(theme.titleColor)
                .shadow(color: theme.titleShadow, radius: 8, x: 0, y: 6)
            if gridLayout == .twoByTwo {
                LazyVGrid(columns: twoByTwoColumns, spacing: 10) {
                    ForEach(displayAlbums.indices, id: \.self) { index in
                        let album = displayAlbums[index]
                        RemoteImage(url: URL(string: album.image.last!.text)!) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.placeholder)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 500, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.black.opacity(0.18), radius: 6, x: 0, y: 4)
                    }
                }
            } else {
                LazyHGrid(rows: rows) {
                    ForEach(displayAlbums.indices, id: \.self) { index in
                        let album = displayAlbums[index]
                        RemoteImage(url: URL(string: album.image.last!.text)!) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.placeholder)
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 500, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: Color.black.opacity(0.18), radius: 6, x: 0, y: 4)
                    }
                }
            }
        }
        .padding(24)
        .background(theme.background)
    }
}

struct TopAlbumsView: View {
    
    @Environment(FmObservables.self) private var fmObservables
    
    @State private var gridLayout: GridLayout = .horizontal
    @State private var selectedTheme: PosterTheme = .midnight
    
    var body: some View {
        @Bindable var fmObservables = fmObservables
        let albums = fmObservables.arrayAlbums
        let posterView = TopAlbumsPoster(
            albums: albums,
            gridLayout: gridLayout,
            theme: selectedTheme
        )
        
        VStack {
            posterView
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Menu {
                    ForEach(GridLayout.allCases) { layout in
                        Button {
                            gridLayout = layout
                        } label: {
                            if gridLayout == layout {
                                Label(layout.rawValue, systemImage: "checkmark")
                            } else {
                                Text(layout.rawValue)
                            }
                        }
                    }
                } label: {
                    Label("Grid", systemImage: "square.grid.2x2")
                }
                Menu {
                    ForEach(PosterTheme.allCases) { theme in
                        Button {
                            selectedTheme = theme
                        } label: {
                            if selectedTheme == theme {
                                Label(theme.rawValue, systemImage: "checkmark")
                            } else {
                                Text(theme.rawValue)
                            }
                        }
                    }
                } label: {
                    Label("Theme", systemImage: "paintpalette.fill")
                }
                Button {
                    Task {
                        await getTopAlbums()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                }
                Button {
                    Task {
                        do {
                            try await saveTopAlbumsAsImage()
                        } catch {
                            print("Saving error: \(error)")
                        }
                    }
                } label: {
                    Image(systemName: "square.and.arrow.down.fill")
                }
            }
        }
        .task {
            await getTopAlbums()
        }
    }
    
    private func saveTopAlbumsAsImage() async throws {
        await getTopAlbums()
        let albums = fmObservables.arrayAlbums
        let posterView = TopAlbumsPoster(
            albums: albums,
            gridLayout: gridLayout,
            theme: selectedTheme
        )
        let renderer = ImageRenderer(content: posterView)
        renderer.scale = 2.0
        guard let nsImage = renderer.nsImage else {
            return
        }
        guard let tiffData = nsImage.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiffData), let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return
        }
        let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("TopAlbums.png")
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        try pngData.write(to: url, options: .atomic)
    }
    
    private func getTopAlbums() async {
        let urls = fmObservables.arrayAlbums.compactMap {
            URL(string: $0.image.last?.text ?? "")
        }
        await ImagePreloader.shared.preload(urls: urls)
    }
}

#Preview {
    TopAlbumsView()
}
