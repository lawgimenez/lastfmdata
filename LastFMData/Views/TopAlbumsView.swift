//
//  TopAlbumsView.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

struct TopAlbumsView: View {
    
    @Environment(FmObservables.self) private var fmObservables
    
    private enum GridLayout: String, CaseIterable, Identifiable {
        case horizontal = "2x8"
        case twoByTwo = "2x2"
        
        var id: String { rawValue }
    }
    
    @State private var gridLayout: GridLayout = .horizontal
    
    private let rows = [
        GridItem(.fixed(300), spacing: 10),
        GridItem(.fixed(300)),
    ]
    
    private let twoByTwoColumns = [
        GridItem(.flexible(minimum: 200), spacing: 10),
        GridItem(.flexible(minimum: 200)),
    ]
    
    var body: some View {
        @Bindable var fmObservables = fmObservables
        let albums = fmObservables.arrayAlbums
        let displayAlbums = gridLayout == .twoByTwo ? Array(albums.prefix(4)) : albums
        VStack {
            Text("Your Last.fm Top Albums")
                .font(.largeTitle)
            if gridLayout == .twoByTwo {
                LazyVGrid(columns: twoByTwoColumns, spacing: 10) {
                    ForEach(displayAlbums.indices, id: \.self) { index in
                        let album = displayAlbums[index]
                        RemoteImage(url: URL(string: album.image.last!.text)!) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.2))
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 500, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            } else {
                LazyHGrid(rows: rows) {
                    ForEach(displayAlbums.indices, id: \.self) { index in
                        let album = displayAlbums[index]
                        RemoteImage(url: URL(string: album.image.last!.text)!) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray.opacity(0.2))
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 500, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
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
        .padding()
    }
    
    private func saveTopAlbumsAsImage() async throws {
        await getTopAlbums()
        let topAlbumsView = body
        let renderer = ImageRenderer(content: topAlbumsView)
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
