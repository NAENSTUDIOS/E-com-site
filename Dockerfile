FROM public.ecr.aws/docker/library/node:20-slim
WORKDIR /app
# Patch OS CRITICALs: libgnutls30 + perl-base (Debian 12)
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD ["node", "-e", "require('http').get('http://localhost:3000/health', r => process.exit(r.statusCode === 200 ? 0 : 1))"]
USER 1000
CMD ["node", "server.js"]
