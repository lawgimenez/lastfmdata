//
//  TopAlbumsView.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

struct TopAlbumsView: View {
    
    @Environment(FmObservables.self) private var fmObservables
    
    let rows = [
        GridItem(.fixed(300), spacing: 10),
        GridItem(.fixed(300)),
    ]
    
    var body: some View {
        @Bindable var fmObservables = fmObservables
        VStack {
            Text("Your Last.fm Top Albums")
                .font(.largeTitle)
            LazyHGrid(rows: rows) {
                ForEach(fmObservables.arrayAlbums.indices, id: \.self) { index in
                    let album = fmObservables.arrayAlbums[index]
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
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Button {
                    
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
            let urls = fmObservables.arrayAlbums.compactMap {
                URL(string: $0.image.last?.text ?? "")
            }
            await ImagePreloader.shared.preload(urls: urls)
        }
        .padding()
    }
    
    private func saveTopAlbumsAsImage() async throws {
        let urls = fmObservables.arrayAlbums.compactMap {
            URL(string: $0.image.last?.text ?? "")
        }
        await ImagePreloader.shared.preload(urls: urls)
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
        try pngData.write(to: url)
    }
}

#Preview {
    TopAlbumsView()
}
