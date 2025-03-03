//
//  CartView.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

struct CartView: View {
    @ObservedObject private var cartManager = CartManager.shared
    @State private var showOrderView = false
    
    var totalPrice: Double {
        cartManager.items.reduce(0) { $0 + $1.album.price * Double($1.quantity) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if cartManager.items.isEmpty {
                    Text("Корзина пуста")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(cartManager.items) { item in
                            HStack(spacing: 12) {
                                Image(item.album.imagePath)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(4)
                                
                                VStack(alignment: .leading) {
                                    Text(item.album.albumName)
                                        .font(.headline)
                                    
                                    HStack {
                                        Button(action: {
                                            updateQuantity(for: item, delta: -1)
                                        }) {
                                            Image(systemName: "minus.circle")
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        
                                        Text("\(item.quantity)")
                                            .padding(.horizontal, 4)
                                        
                                        Button(action: {
                                            updateQuantity(for: item, delta: 1)
                                        }) {
                                            Image(systemName: "plus.circle")
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                    }
                                    .font(.subheadline)
                                }
                                
                                Spacer()
                                Text(String(format: "$%.2f", item.album.price * Double(item.quantity)))
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: cartManager.remove)
                    }
                    
                    HStack {
                        Text("Общая цена:")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", totalPrice))
                            .font(.headline)
                    }
                    .padding([.horizontal, .top])
                    
                    Button(action: {
                        showOrderView = true
                    }) {
                        Text("Оформить заказ")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Корзина")
        }
        .fullScreenCover(isPresented: $showOrderView) {
            OrderView()
        }
    }
    
    private func updateQuantity(for item: CartItem, delta: Int) {
        if let index = cartManager.items.firstIndex(where: { $0.id == item.id }) {
            let newQuantity = cartManager.items[index].quantity + delta
            if newQuantity <= 0 {
                cartManager.items.remove(at: index)
            } else {
                cartManager.items[index].quantity = newQuantity
            }
        }
    }
}
