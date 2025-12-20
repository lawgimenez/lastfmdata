//
//  ImageLoader.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import Foundation
import AppKit

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: NSImage?

    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func load() {
        let nsURL = url as NSURL

        if let cached = ImageCache.shared.image(for: nsURL) {
            image = cached
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let nsImage = NSImage(data: data) else { return }

                ImageCache.shared.insert(nsImage, for: nsURL)
                image = nsImage
            } catch {
                // Silently fail or log if you want
            }
        }
    }
}
