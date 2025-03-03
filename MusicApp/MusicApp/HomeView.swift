//
//  HomeView.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var topAlbum: Album?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Топ-1 альбом по рейтингу:")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                if let album = topAlbum {
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        HStack(spacing: 4) {
                            // Изображение берется из Assets.xcassets, имя соответствует imagePath
                            Image(album.imagePath)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(album.albumName)
                                    .font(.headline)
                                
                                Text(album.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    Text(album.genre)
                                        .font(.caption)
                                    Spacer()
                                    Text(String(album.releaseDate.prefix(4)))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text("Рейтинг: \(album.rating, specifier: "%.1f")")
                                        .font(.caption)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal)
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text("Загрузка данных...")
                        .padding()
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Добро пожаловать")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // При появлении экрана запрашиваем топовый альбом из БД
                topAlbum = DatabaseManager.shared.fetchTopAlbum()
            }
        }
    }
}
