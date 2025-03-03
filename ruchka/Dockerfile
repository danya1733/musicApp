FROM golang:1.24

WORKDIR /usr/src/app

# Копируем файлы зависимостей для кэширования и предварительной загрузки зависимостей
COPY go.mod go.sum ./
RUN go mod download

# Копируем исходный код и собираем приложение
COPY . .
RUN go build -v -o /usr/local/bin/app ./...

# Приложение слушает порты 8080 и 8081, поэтому их можно указать для наглядности
EXPOSE 8080

CMD ["app"]
