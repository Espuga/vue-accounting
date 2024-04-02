# Usa la imagen oficial de Node.js como base para construir tu aplicación
FROM node:lts-alpine AS builder

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de configuración
COPY package*.json ./

# Instala las dependencias
RUN npm install

# Copia los archivos de la aplicación
COPY . .

# Compila la aplicación
RUN npm run build

# Usa la imagen oficial de Nginx como base para servir los archivos estáticos
FROM nginx:alpine

# Copia los archivos construidos desde la etapa anterior a la carpeta de Nginx
COPY --from=builder /app/dist /usr/share/nginx/html

# Agrega una configuración personalizada para Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf