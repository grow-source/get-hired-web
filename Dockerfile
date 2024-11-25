FROM node:20-alpine AS base

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

RUN npm install --force

FROM base AS builder

WORKDIR /app

COPY --from=base /app/node_modules ./node_modules
COPY . .

RUN npm run build

FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

RUN addgroup -S nodejs
RUN adduser -S -D -H nextjs -G nodejs
RUN mkdir .next
RUN chown nextjs:nodejs .next

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

USER nextjs

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost:3000/health || exit 1

EXPOSE 3000

CMD ["node", "server.js"]
