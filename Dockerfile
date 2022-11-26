FROM node:16.13.1-alpine

RUN apk --no-cache add dumb-init
RUN mkdir -p /home/node/app && chown node:node /home/node/app
COPY .env /home/node/app/.env
WORKDIR /home/node/app
USER node
RUN mkdir tmp

COPY --chown=node:node ./package*.json ./
RUN npm ci
COPY --chown=node:node . .

RUN node ace build --production

ENV NODE_ENV=production
ENV PORT=$PORT
ENV HOST=0.0.0.0
COPY --chown=node:node ./package*.json ./
RUN npm ci --production
# COPY --chown=node:node --from=build /home/node/app/build .
EXPOSE $PORT
CMD [ "dumb-init", "node", "server.js" ]
