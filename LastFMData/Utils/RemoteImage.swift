//
//  RemoteImage.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

struct RemoteImage<Placeholder: View>: View {
    let url: URL
    let placeholder: Placeholder

    init(url: URL, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder()
    }

    var body: some View {
        if let image = ImageCache.shared.image(for: url as NSURL) {
            Image(nsImage: image)
                .resizable()
        } else {
            AsyncImage(url: url) { image in
                image.image?.resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: 500, maxHeight: 500)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

