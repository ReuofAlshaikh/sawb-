# Demo server + admin dashboard in one container (Render, Railway, Fly.io, any Docker host).
FROM node:22-slim
WORKDIR /app
COPY package.json package-lock.json ./
COPY packages/shared/package.json packages/shared/
COPY apps/server/package.json apps/server/
COPY apps/admin/package.json apps/admin/
COPY apps/mobile/package.json apps/mobile/
RUN npm ci -w @sawb/shared -w @sawb/server -w @sawb/admin --include-workspace-root
COPY packages/shared packages/shared
COPY apps/server apps/server
COPY apps/admin apps/admin
RUN npm run build -w @sawb/admin
ENV PORT=4000 SAWB_DATA=/data/db.json
VOLUME /data
EXPOSE 4000
CMD ["npm", "run", "start", "-w", "@sawb/server"]
