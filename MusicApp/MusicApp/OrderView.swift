//
//  OrderView.swift
//  MusicApp
//
//  Created by Danila on 22.02.2025.
//

import SwiftUI

struct OrderView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var cartManager = CartManager.shared
    
    @State private var fullName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var address = ""
    @State private var showThankYouAlert = false
    
    var totalPrice: Double {
        cartManager.items.reduce(0) { $0 + $1.album.price * Double($1.quantity) }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Контактные данные")) {
                    TextField("ФИО", text: $fullName)
                    TextField("Телефон", text: $phone)
                    TextField("Email", text: $email)
                    TextField("Адрес", text: $address)
                }
                
                Section(header: Text("Ваш заказ")) {
                    ForEach(cartManager.items) { item in
                        HStack {
                            Text(item.album.albumName)
                            Spacer()
                            Text("x\(item.quantity)")
                        }
                    }
                    HStack {
                        Text("Общая цена:")
                        Spacer()
                        Text(String(format: "$%.2f", totalPrice))
                    }
                }
                
                Section {
                    Button(action: {
                        // Собираем информацию о заказе
                        let orderInfo = """
                        Заказ оформлен
                        ФИО: \(fullName)
                        Телефон: \(phone)
                        Email: \(email)
                        Адрес: \(address)
                        \(cartManager.items.map { "\($0.album.albumName) x\($0.quantity)" }.joined(separator: "\n"))
                        Общая цена: \(String(format: "$%.2f", totalPrice))
                        """
                        
                        // Формируем JSON с ключом "Text"
                        let payload: [String: String] = ["Text": orderInfo]
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
                            print("Ошибка сериализации JSON")
                            return
                        }
                        
                        // Создаем URL и URLRequest
                        guard let url = URL(string: "http://danya1733.ru:8080/newOrder") else {
                            print("Некорректный URL")
                            return
                        }
                        var request = URLRequest(url: url)
                        request.httpMethod = "POST"
                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        request.httpBody = jsonData
                        
                        // Отправляем запрос
                        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                            if let error = error {
                                print("Ошибка запроса: \(error)")
                                return
                            }
                            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                                print("Заказ успешно отправлен")
                            } else {
                                print("Ошибка сервера")
                            }
                        }
                        task.resume()
                        
                        // Показываем Alert (UI обновляем в главном потоке)
                        DispatchQueue.main.async {
                            showThankYouAlert = true
                        }
                    }) {
                        Text("Заказать")
                            .frame(maxWidth: .infinity)
                    }

                }
            }
            .navigationBarTitle("Оформление заказа", displayMode: .inline)
            .navigationBarItems(trailing: Button("Отмена") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showThankYouAlert) {
                Alert(title: Text("Спасибо за заказ!"),
                      dismissButton: .default(Text("ОК"), action: {
                        // Очистка корзины и закрытие экрана заказа
                        cartManager.items.removeAll()
                        presentationMode.wrappedValue.dismiss()
                      }))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
