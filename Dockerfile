# 🔹 Build Stage
FROM node:20 AS build

WORKDIR /app

RUN npm install -g npm@9

COPY package*.json ./

RUN npm ci --legacy-peer-deps

COPY . .

RUN npm run build

# 🔹 Production Stage
FROM docker.io/library/nginx:alpine

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
