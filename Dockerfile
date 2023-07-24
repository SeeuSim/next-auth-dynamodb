FROM node:18.17-alpine3.17 as base

RUN apk update
RUN apk --no-cache upgrade
RUN apk add --no-cache libc6-compat
RUN yarn global add pnpm

FROM base as deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

FROM base as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN pnpm build

FROM base as rnner
WORKDIR /app
RUN addgroup --system --gid 1001 nodejs \
  && adduser --system --uid 10001 nextjs \
  && chown -R nextjs:nodejs /app

COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# ENV GITHUB_ID=$GITHUB_ID
# ENV GITHUB_SECRET=$GITHUB_SECRET
# ENV NEXT_AUTH_AWS_ACCESS_KEY=$NEXT_AUTH_AWS_ACCESS_KEY
# ENV NEXT_AUTH_AWS_SECRET_KEY=$NEXT_AUTH_AWS_SECRET_KEY
# ENV NEXT_AUTH_AWS_REGION=$NEXT_AUTH_AWS_REGION
# ENV NEXT_AUTH_DYNAMO_ENDPOINT=$NEXT_AUTH_DYNAMO_ENDPOINT
# ENV NEXTAUTH_URL=$NEXTAUTH_URL
# ENV NEXTAUTH_SECRET=$NEXTAUTH_SECRET

USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
