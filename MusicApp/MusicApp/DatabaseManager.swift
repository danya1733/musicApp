//
//  DatabaseManager.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//
import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    var db: OpaquePointer?
    
    private init() {
        openDatabase()
        createAlbumsTable()
        populateDataIfNeeded()
    }
    
    private func getDatabasePath() -> String {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        return documentsDirectory.appendingPathComponent("musicapp.sqlite").path
    }
    
    private func openDatabase() {
        let dbPath = getDatabasePath()
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("БД открыта/создана по пути: \(dbPath)")
        } else {
            print("Ошибка при открытии БД")
        }
    }
    
    private func createAlbumsTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Albums(
            Id INTEGER PRIMARY KEY AUTOINCREMENT,
            artist TEXT,
            albumName TEXT,
            releaseDate TEXT,
            genre TEXT,
            country TEXT,
            description TEXT,
            price REAL,
            quantity INTEGER,
            rating REAL,
            imagePath TEXT
        );
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Таблица Albums создана успешно.")
            } else {
                print("Не удалось создать таблицу Albums.")
            }
        } else {
            print("Ошибка подготовки запроса создания таблицы.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    private func populateDataIfNeeded() {
        let countQuery = "SELECT COUNT(*) FROM Albums;"
        var countStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, countQuery, -1, &countStatement, nil) == SQLITE_OK {
            if sqlite3_step(countStatement) == SQLITE_ROW {
                let count = sqlite3_column_int(countStatement, 0)
                if count == 0 {
                    insertInitialData()
                }
            }
        }
        sqlite3_finalize(countStatement)
    }
    
    private func insertInitialData() {
        let albums: [[Any]] = [
            ["Metallica", "Master of Puppets", "1986", "Thrash Metal", "USA", "Один из самых значимых альбомов в истории металла.", 12.99, 10, 5.0, "master_of_puppets"],
            ["Nirvana", "Nevermind", "1991", "Grunge", "USA", "Альбом, определивший звучание 90-х.", 10.99, 5, 4.8, "nevermind"],
            ["Arctic Monkeys", "AM", "2013", "Indie Rock", "UK", "Современный классик с элементами рока и R&B.", 9.99, 7, 4.5, "am"],
            ["Pink Floyd", "The Dark Side of the Moon", "1973", "Progressive Rock", "UK", "Один из самых влиятельных прогрессивных альбомов в истории.", 11.99, 8, 5.0, "dark_side"],
           ["Radiohead", "OK Computer", "1997", "Alternative Rock", "UK", "Знаковый альбом, задавший вектор для альтернативного рока.", 10.49, 6, 4.9, "ok_computer"],
           ["The Beatles", "Abbey Road", "1969", "Rock", "UK", "Классика британского рока, важный этап в истории группы.", 13.99, 12, 5.0, "abbey_road"],
           ["Queen", "A Night at the Opera", "1975", "Rock", "UK", "Грандиозное сочетание оперной и рок-музыки.", 12.49, 9, 4.8, "night_at_the_opera"],
           ["Led Zeppelin", "Led Zeppelin IV", "1971", "Hard Rock", "UK", "Легендарный альбом с культовыми композициями.", 14.99, 7, 5.0, "zeppelin_iv"],
           ["AC/DC", "Back in Black", "1980", "Hard Rock", "Australia", "Один из самых продаваемых альбомов в истории рока.", 13.49, 11, 4.9, "back_in_black"],
           ["U2", "The Joshua Tree", "1987", "Rock", "Ireland", "Эпический альбом, символ эпохи 80-х.", 12.99, 10, 4.7, "joshua_tree"],
           ["Bob Dylan", "Highway 61 Revisited", "1965", "Folk Rock", "USA", "Иконический альбом с глубокими текстами.", 10.99, 8, 4.8, "highway_61"],
           ["Kanye West", "My Beautiful Dark Twisted Fantasy", "2010", "Hip Hop", "USA", "Амбициозный и экспериментальный альбом, признанный критиками.", 11.49, 9, 4.9, "dark_twisted_fantasy"],
           ["Daft Punk", "Discovery", "2001", "Electronic", "France", "Переосмысление электронной музыки с элементами диско.", 9.99, 10, 4.7, "discovery"],
           ["Adele", "21", "2011", "Pop/Soul", "UK", "Всемирно известный альбом, принесший мировой успех певице.", 10.49, 15, 4.8, "21"]
           ]
        
        let insertStatementString = """
        INSERT INTO Albums (artist, albumName, releaseDate, genre, country, description, price, quantity, rating, imagePath)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            for album in albums {
                sqlite3_bind_text(insertStatement, 1, (album[0] as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (album[1] as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (album[2] as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (album[3] as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (album[4] as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, (album[5] as! NSString).utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 7, album[6] as! Double)
                sqlite3_bind_int(insertStatement, 8, Int32(album[7] as! Int))
                sqlite3_bind_double(insertStatement, 9, album[8] as! Double)
                sqlite3_bind_text(insertStatement, 10, (album[9] as! NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Запись успешно добавлена.")
                } else {
                    print("Не удалось добавить запись.")
                }
                sqlite3_reset(insertStatement)
            }
        } else {
            print("Ошибка подготовки запроса вставки.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    // Функция выборки топ-1 альбома по рейтингу из БД
    func fetchTopAlbum() -> Album? {
        let query = "SELECT * FROM Albums ORDER BY rating DESC LIMIT 1;"
        var queryStatement: OpaquePointer?
        var topAlbum: Album?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let artist = String(cString: sqlite3_column_text(queryStatement, 1))
                let albumName = String(cString: sqlite3_column_text(queryStatement, 2))
                let releaseDate = String(cString: sqlite3_column_text(queryStatement, 3))
                let genre = String(cString: sqlite3_column_text(queryStatement, 4))
                let country = String(cString: sqlite3_column_text(queryStatement, 5))
                let description = String(cString: sqlite3_column_text(queryStatement, 6))
                let price = sqlite3_column_double(queryStatement, 7)
                let quantity = Int(sqlite3_column_int(queryStatement, 8))
                let rating = sqlite3_column_double(queryStatement, 9)
                let imagePath = String(cString: sqlite3_column_text(queryStatement, 10))
                
                topAlbum = Album(id: id,
                                 artist: artist,
                                 albumName: albumName,
                                 releaseDate: releaseDate,
                                 genre: genre,
                                 country: country,
                                 albumDescription: description,
                                 price: price,
                                 quantity: quantity,
                                 rating: rating,
                                 imagePath: imagePath)
            }
        } else {
            print("Ошибка подготовки запроса выборки топового альбома.")
        }
        sqlite3_finalize(queryStatement)
        return topAlbum
    }
    
    func fetchAllAlbums() -> [Album] {
        let query = "SELECT * FROM Albums;"
        var queryStatement: OpaquePointer?
        var albums: [Album] = []
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let artist = String(cString: sqlite3_column_text(queryStatement, 1))
                let albumName = String(cString: sqlite3_column_text(queryStatement, 2))
                let releaseDate = String(cString: sqlite3_column_text(queryStatement, 3))
                let genre = String(cString: sqlite3_column_text(queryStatement, 4))
                let country = String(cString: sqlite3_column_text(queryStatement, 5))
                let description = String(cString: sqlite3_column_text(queryStatement, 6))
                let price = sqlite3_column_double(queryStatement, 7)
                let quantity = Int(sqlite3_column_int(queryStatement, 8))
                let rating = sqlite3_column_double(queryStatement, 9)
                let imagePath = String(cString: sqlite3_column_text(queryStatement, 10))
                
                let album = Album(id: id,
                                  artist: artist,
                                  albumName: albumName,
                                  releaseDate: releaseDate,
                                  genre: genre,
                                  country: country,
                                  albumDescription: description,
                                  price: price,
                                  quantity: quantity,
                                  rating: rating,
                                  imagePath: imagePath)
                albums.append(album)
            }
        } else {
            print("Ошибка подготовки запроса выборки альбомов.")
        }
        sqlite3_finalize(queryStatement)
        return albums
    }

    
}
