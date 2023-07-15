//
//  ContentView.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 7/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var arrayAlbums = [TopAlbums.Album]()
    
    let rows = [
        GridItem(.fixed(150), spacing: 150),
        GridItem(.fixed(150)),
    ]
    
    var body: some View {
        VStack {
            Text("Your top albums from 30 Jun 2023 — 6 Jul 2023")
                .font(.largeTitle)
            Divider()
            LazyHGrid(rows: rows) {
                ForEach(arrayAlbums, id: \.id) { album in
                    let _ = print("album = \(album.image.last!.text)")
                    AsyncImage(url: URL(string: album.image.last!.text))
//                        .aspectRatio(contentMode: .fit)
                }
            }
        }
        .task {
            await getTopAlbums()
        }
        .padding()
    }
    
    private func getTopAlbums() async {
        if let url = URL(string: "https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=xthekingisdeadx&api_key=[key-here]&format=json&period=7day&limit=8") {
            print("url")
            let session = URLSession.shared
            let request = URLRequest(url: url)
            print("request")
            let task = session.dataTask(with: request) {
                data, response, error in
                if let error {
                    print(error)
                } else {
                    if let data {
                        do {
                            let topAlbums = try JSONDecoder().decode(TopAlbums.self, from: data)
                            arrayAlbums = topAlbums.topAlbum.album
//                            print("topAlbums = \(topAlbums)")
                        } catch {
                            print("Parser error = \(error)")
                        }
                    } else {
                        print("no data")
                    }
                }
            }
            task.resume()
        } else {
            print("url error")
        }
    }
}

//#Preview {
//    ContentView()
//}
