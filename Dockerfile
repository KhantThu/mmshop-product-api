FROM node:18.20.6-bookworm AS builder

WORKDIR /usr/local/app/

COPY package.json ./

COPY prisma ./

RUN npm install && npx prisma generate

COPY . .

RUN npm run build

FROM node:18.20.6-alpine AS runner

COPY --from=builder /usr/local/app/package*.json ./
COPY --from=builder /usr/local/app/dist ./dist
COPY --from=builder /usr/local/app/prisma ./prisma
COPY --from=builder /usr/local/app/generated ./generated
COPY --from=builder /usr/local/app/node_modules ./node_modules

EXPOSE 3000

#USER Node or add --user

ENTRYPOINT ["npm"]

CMD ["run","start:prod"]


