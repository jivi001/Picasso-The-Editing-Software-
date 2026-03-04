FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json package-lock.json* ./
COPY backend/package.json backend/package.json
COPY frontend/package.json frontend/package.json

RUN npm install

COPY backend ./backend
COPY database ./database

RUN npm run build --workspace backend

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY package.json package-lock.json* ./
COPY backend/package.json backend/package.json

RUN npm install --omit=dev --workspace backend --include-workspace-root=false

COPY --from=builder /app/backend/dist ./backend/dist
COPY --from=builder /app/database ./database

WORKDIR /app/backend
EXPOSE 4000
CMD ["node", "dist/server.js"]
