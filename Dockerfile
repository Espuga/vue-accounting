# Usa una imagen base con Node.js
FROM node:14

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia los archivos de la aplicación al contenedor
COPY . .

# Instala las dependencias
RUN npm install

# Compila la aplicación
RUN npm run build

# Expone el puerto en el que la aplicación se ejecutará
EXPOSE 8080

# Comando para iniciar la aplicación cuando el contenedor se inicia
CMD ["npm", "run", "start"]
