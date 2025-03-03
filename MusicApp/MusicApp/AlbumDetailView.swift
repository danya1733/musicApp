//
//  AlbumDetailView.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    @State private var quantity: Int = 1
    @State private var showAddedMessage = false
    @ObservedObject private var cartManager = CartManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(album.imagePath)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
                Text(album.albumName)
                    .font(.largeTitle)
                    .bold()
                
                Text("Исполнитель: \(album.artist)")
                    .font(.headline)
                
                Text("Год выпуска: \(String(album.releaseDate.prefix(4)))")
                    .font(.subheadline)
                
                Text("Жанр: \(album.genre)")
                    .font(.subheadline)
                
                Text("Цена: \(String(format: "$%.2f", album.price))")
                    .font(.subheadline)
                
                Text("Рейтинг: \(album.rating, specifier: "%.1f")")
                    .font(.subheadline)
                
                Text(album.albumDescription)
                    .font(.body)
                
                HStack {
                    Text("Количество: \(quantity)")
                    Spacer()
                    Stepper("", value: $quantity, in: 1...album.quantity)
                        .labelsHidden()
                }
                .padding(.vertical)
                
                Button(action: {
                    cartManager.add(album: album, quantity: quantity)
                    withAnimation {
                        showAddedMessage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showAddedMessage = false
                        }
                    }
                }) {
                    Text("Добавить в корзину")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .navigationTitle(album.albumName)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            Group {
                if showAddedMessage {
                    Text("Товар добавлен в корзину")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.move(edge: .top))
                        .zIndex(1)
                }
            },
            alignment: .top
        )
    }
}
