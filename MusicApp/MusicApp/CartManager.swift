//
//  CartManager.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import Foundation
import SwiftUI

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published var items: [CartItem] = [] {
        didSet {
            saveItems()
        }
    }
    
    private let userDefaultsKey = "cartItems"
    
    private init() {
        loadItems()
    }
    
    func add(album: Album, quantity: Int) {
        if let index = items.firstIndex(where: { $0.album.id == album.id }) {
            items[index].quantity += quantity
        } else {
            let newItem = CartItem(album: album, quantity: quantity)
            items.append(newItem)
        }
    }
    
    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    private func saveItems() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedItems = try? JSONDecoder().decode([CartItem].self, from: data) {
            self.items = savedItems
        }
    }
}
