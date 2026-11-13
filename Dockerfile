# Etapa 1: Construcción (Build)
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias
COPY package*.json ./
RUN npm install

# Copiar el código fuente
COPY . .

# Variable de entorno para Vite (se hornea en tiempo de build)
ARG VITE_POKEAPI_URL=https://pokeapi.co/api/v2
ENV VITE_POKEAPI_URL=$VITE_POKEAPI_URL

# Compilar los archivos estáticos
RUN npm run build

# Etapa 2: Servidor de Producción (Nginx)
FROM nginx:alpine

# Copiar configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar artefactos compilados desde la etapa de build
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer el puerto 80
EXPOSE 80

# Iniciar Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
