//
//  CatalogView.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

struct CatalogView: View {
    @State private var albums: [Album] = []
    
    var body: some View {
        NavigationView {
            List(albums) { album in
                NavigationLink(destination: AlbumDetailView(album: album)) {
                    HStack(spacing: 12) {
                        Image(album.imagePath)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(4)
                        
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
                                Spacer()
                                Text(String(format: "$%.2f", album.price))
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Каталог")
        }
        .onAppear {
            albums = DatabaseManager.shared.fetchAllAlbums()
        }
    }
}
