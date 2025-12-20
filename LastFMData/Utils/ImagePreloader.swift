//
//  ImagePreloader.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import Foundation
import AppKit

@MainActor
final class ImagePreloader {
    static let shared = ImagePreloader()

    func preload(urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    let nsURL = url as NSURL

                    if ImageCache.shared.image(for: nsURL) != nil {
                        return
                    }

                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = NSImage(data: data) {
                            ImageCache.shared.insert(image, for: nsURL)
                        }
                    } catch {
                        // Ignore failures or log
                    }
                }
            }
        }
    }
}
