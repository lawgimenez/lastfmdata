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
        GridItem(.fixed(300), spacing: 10),
        GridItem(.fixed(300)),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Last.fm Top Albums")
                    .font(.largeTitle)
                LazyHGrid(rows: rows) {
                    ForEach(arrayAlbums, id: \.id) { album in
                        AsyncImage(url: URL(string: album.image.last!.text)) { image in
                            image.image?.resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(maxWidth: 500, maxHeight: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .task {
                await getTopAlbums()
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.down.fill")
                    }
                }
            }
            .padding()
        }
    }
    
    private func getTopAlbums() async {
        if let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "LastFMAPIKey"
        ) as? String {
            if let url = URL(string: "https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=lawrencegimenez&api_key=\(apiKey)&format=json&period=7day&limit=8") {
                print("url is \(url)")
                let session = URLSession.shared
                let request = URLRequest(url: url)
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
}

//#Preview {
//    ContentView()
//}
