FROM docker.io/library/node:20.11.1-alpine

RUN apk add --no-cache python3 make g++

ARG VCS_REF=master
ARG BUILD_DATE=""
ARG REGISTRY_PATH=docker.io/paritytech
ARG PROJECT_NAME=""

LABEL io.parity.image.authors="cicd-team@parity.io" \
    io.parity.image.vendor="Parity Technologies" \
    io.parity.image.title="${REGISTRY_PATH}/${PROJECT_NAME}-faucet" \
    io.parity.image.description="Generic Faucet for Substrate based chains" \
    io.parity.image.source="https://github.com/paritytech/${PROJECT_NAME}/blob/${VCS_REF}/Dockerfile" \
    io.parity.image.documentation="https://github.com/paritytech/${PROJECT_NAME}/blob/${VCS_REF}/README.md" \
    io.parity.image.revision="${VCS_REF}" \
    io.parity.image.created="${BUILD_DATE}"

WORKDIR /faucet

COPY ./package.json ./yarn.lock ./polkadot-api.json ./
RUN yarn --frozen-lockfile

COPY . .
RUN yarn build

CMD yarn migrations:run && yarn start
