//
//  Album.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import Foundation

struct Album: Identifiable, Codable {
    let id: Int
    let artist: String
    let albumName: String
    let releaseDate: String
    let genre: String
    let country: String
    let albumDescription: String
    let price: Double
    let quantity: Int
    let rating: Double
    let imagePath: String
}
