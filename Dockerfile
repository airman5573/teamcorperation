FROM node:18-bullseye-slim

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install --omit=dev --no-audit --no-fund

COPY . .

EXPOSE 8081

CMD ["node", "src/index.js"]
