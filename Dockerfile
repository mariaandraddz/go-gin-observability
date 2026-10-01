# Estágio 1: Build da aplicação
FROM golang:1.27-alpine AS builder

WORKDIR /app

# Copia os arquivos de gerenciamento de dependências
COPY go.mod go.sum ./

# Baixa as dependências
RUN go mod download

# Copia todo o código-fonte
COPY . .

# Compila o binário de forma estática (desativando CGO)
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Estágio 2: Imagem final mínima
FROM scratch

WORKDIR /app

# Copia o binário compilado do estágio anterior
COPY --from=builder /app/main .

# Expõe a porta onde a API roda
EXPOSE 8080

# Executa a aplicação
CMD ["./main"]