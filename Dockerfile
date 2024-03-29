FROM oven/bun:slim as base
WORKDIR /usr/src/app

FROM base AS install
ARG NODE_VERSION=20
RUN apt update \
  && apt install -y curl
RUN curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n \
  && bash n $NODE_VERSION \
  && rm n \
  && npm install -g n

COPY . .
RUN bun install --production
RUN bun x prisma generate

ENV NODE_ENV production
USER bun
EXPOSE 3000/tcp
ENTRYPOINT [ "bun", "run", "src/index.ts" ]