//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

@main
struct MusicAppApp: App {
    init() {
        // Инициализируем базу данных при запуске приложения
        _ = DatabaseManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
