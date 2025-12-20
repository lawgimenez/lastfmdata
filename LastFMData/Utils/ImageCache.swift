//
//  ImageCache.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSURL, NSImage>()

    func image(for url: NSURL) -> NSImage? {
        cache.object(forKey: url)
    }

    func insert(_ image: NSImage, for url: NSURL) {
        cache.setObject(image, forKey: url)
    }
}

