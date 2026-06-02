FROM node:20-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

RUN npm ci --omit=dev

FROM node:20-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

RUN addgroup -S shopswift && adduser -S shopswift -G shopswift

COPY --from=dependencies /app/node_modules ./node_modules
COPY src ./src
COPY package*.json ./

USER shopswift

EXPOSE 3000

CMD ["node", "src/server.js"]
