//
//  CartItem.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import Foundation

struct CartItem: Identifiable, Codable {
    let id = UUID()
    let album: Album
    var quantity: Int
}
