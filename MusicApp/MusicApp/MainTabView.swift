//
//  MainTabView.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Главная")
                }
                .tag(0)
            
            CatalogView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                    Text("Каталог")
                }
                .tag(1)
            
            CartView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "cart.fill" : "cart")
                    Text("Корзина")
                }
                .tag(2)
            
            AboutView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Обо мне")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

