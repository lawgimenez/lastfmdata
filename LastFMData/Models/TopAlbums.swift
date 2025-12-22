//
//  TopAlbums.swift
//  LastFMData
//
//  Created by Lawrence Gimenez on 7/8/23.
//

import Foundation

struct TopAlbums: Decodable {
    
    var topAlbum: TopAlbum
    
    enum CodingKeys: String, CodingKey {
        case topAlbum = "topalbums"
    }
    
    struct TopAlbum: Decodable, Identifiable {
        
        let id = UUID()
        var album: [Album]
    }
    
    struct Album: Decodable, Identifiable {
        
        let id = UUID()
        var artist: Artist
        var playCount: String
        var image: [Image]
        
        enum CodingKeys: String, CodingKey {
            case id
            case artist
            case playCount = "playcount"
            case image
        }
    }
    
    struct Artist: Decodable {
        
        var url: String
        var name: String
    }
    
    struct Image: Decodable {
        
        var size: String
        var text: String
        
        enum CodingKeys: String, CodingKey {
            case size
            case text = "#text"
        }
    }
}
