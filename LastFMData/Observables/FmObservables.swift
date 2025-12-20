//
//  FmObservables.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 12/20/25.
//

import SwiftUI

@Observable
class FmObservables {
    
    var arrayAlbums = [TopAlbums.Album]()
    
    func getTopAlbums() {
        if let apiKey = Bundle.main.object(
            forInfoDictionaryKey: "LastFMAPIKey"
        ) as? String {
            if let url = URL(string: "https://ws.audioscrobbler.com/2.0/?method=user.gettopalbums&user=lawrencegimenez&api_key=\(apiKey)&format=json&period=7day&limit=8") {
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
                                self.arrayAlbums = topAlbums.topAlbum.album
                            } catch {
                                print("Parser error = \(error)")
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
