FROM docker.io/node:20-slim as base

# Enable corepack.
RUN corepack enable

USER 1000:1000
WORKDIR /app

# Install NPM dependencies
# Note: it mounts the cached ~/.npm folder generated by previous builds
#       (docs: https://docs.npmjs.com/cli/v10/using-npm/config#cache)
COPY --chown=1000:1000 ./package.json ./package-lock.json /app/
RUN --mount=type=cache,mode=0700,uid=1000,gid=1000,target=/home/node/.npm \
	npm ci

# Copy source files (ordered from least likely to be updated, up to the most likely)
COPY --chown=1000:1000 ./.eslintrc ./.lintstagedrc ./*.js /app/
COPY --chown=1000:1000 ./scripts /app/scripts/
COPY --chown=1000:1000 ./src /app/src/
COPY --chown=1000:1000 ./static /app/static/
COPY --chown=1000:1000 ./template /app/template/
COPY --chown=1000:1000 ./components /app/components/
COPY --chown=1000:1000 ./sidebars /app/sidebars/
COPY --chown=1000:1000 ./docs /app/docs/

FROM base as dev
CMD ["npm", "start", "--", "--host=0.0.0.0", "--port=5000"]

