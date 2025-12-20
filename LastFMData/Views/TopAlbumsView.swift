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
                ForEach(fmObservables.arrayAlbums, id: \.id) { album in
                    AsyncImage(url: URL(string: album.image.last!.text)) { image in
                        image.image?.resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(maxWidth: 500, maxHeight: 500)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    do {
                        try saveTopAlbumsAsImage()
                    } catch {
                        print("Saving error: \(error)")
                    }
                } label: {
                    Image(systemName: "square.and.arrow.down.fill")
                }
            }
        }
        .padding()
    }
    
    private func saveTopAlbumsAsImage() throws {
        let topAlbumsView = body
        let renderer = ImageRenderer(content: topAlbumsView)
        renderer.scale = 2.0
        guard let nsImage = renderer.nsImage else {
            return
        }
        guard let tiffData = nsImage.tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiffData), let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return
        }
        print("PNG data found")
        let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("TopAlbums.png")
        print("Saving to downloads")
        try pngData.write(to: url)
    }
}

#Preview {
    TopAlbumsView()
}
