package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/smtp"
)

type message struct {
	Text string `json:"text"`
}

func main() {
	from := ""             //почта gmali
	password := ""         //пароль от почты
	toList := []string{""} // список фдрессов для отправки заказов
	host := "smtp.gmail.com"
	port := 587
	auth := smtp.PlainAuth("", from, password, host)

	http.HandleFunc("/newOrder", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			w.Write([]byte("Order created"))
			var m message
			err := json.NewDecoder(r.Body).Decode(&m)
			if err != nil {
				http.Error(w, err.Error(), http.StatusBadRequest)
				return
			}
			msg := m.Text
			body := []byte(msg)
			err = smtp.SendMail(fmt.Sprintf("%s:%d", host, port), auth, from, toList, body)
			if err != nil {
				fmt.Println(err)
			}
			fmt.Println(m.Text)
		} else {
			http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
		}
	})

	http.ListenAndServe(":8080", nil)

}
