# Multi-stage Phoenix release for jheni.pink (sqlite, no node).
# Update ARG tags if you bump Elixir/OTP/Debian. Match your local versions.
ARG ELIXIR_VERSION=1.19.5
ARG OTP_VERSION=28.1.2
ARG DEBIAN_VERSION=bookworm-20251028-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} AS builder

# install build deps (sqlite needs libsqlite3-dev to compile ecto_sqlite3 NIF)
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      build-essential git curl libsqlite3-dev pkg-config && \
    apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

# prepare build env
RUN mix local.hex --force && mix local.rebar --force
ENV MIX_ENV=prod

# install mix deps first for cache
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config (config.exs imports the env-specific file)
COPY config/config.exs config/prod.exs config/
RUN mix deps.compile

# copy app sources
COPY priv priv
COPY lib lib
COPY assets assets

# build assets (esbuild only -- no node/tailwind)
RUN mix assets.deploy

# runtime config + release
COPY config/runtime.exs config/
COPY rel rel
RUN mix release

# ---------------------------------------------------------------------------
# runtime image -- smaller, only what BEAM/SQLite need
FROM ${RUNNER_IMAGE} AS runner

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      libstdc++6 openssl libncurses6 locales ca-certificates libsqlite3-0 && \
    apt-get clean && rm -f /var/lib/apt/lists/*_*

# UTF-8 locale -- elixir/erlang play nicer
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

# default location of the sqlite volume (also referenced by fly.toml [mounts])
ENV DATABASE_PATH=/data/site.db
RUN mkdir -p /data && chown nobody /data

# only the compiled release artifact -- no source, no deps, no mix
ENV MIX_ENV=prod
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/site ./

USER nobody

CMD ["/app/bin/server"]
