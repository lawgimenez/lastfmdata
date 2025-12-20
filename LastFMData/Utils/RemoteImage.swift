//
//  RemoteImage.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

struct RemoteImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder

    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder
    ) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder()
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(nsImage: image)
                    .resizable()
            } else {
                placeholder
            }
        }
        .onAppear {
            loader.load()
        }
    }
}
