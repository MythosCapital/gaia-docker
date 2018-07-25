#!/bin/bash -e

set -x

: ${GAIA_HOME:=/etc/gaiad}

if [ -n "$GAIAD_INIT" ]; then
  gaiad init --name $MONIKER --home $GAIA_HOME
  exit 0
fi

if [ -f /tmp/genesis.json ]; then
  cp /tmp/genesis.json ${GAIA_HOME}/config
fi

if [ -f /tmp/config.toml ]; then
  cp /tmp/config.toml ${GAIA_HOME}/config
fi

if [ -f /tmp/priv_validator.json ]; then
  cp /tmp/priv_validator.json ${GAIA_HOME}/config
fi

if [ -n "$SEEDS" ]; then
  sed -i 's/^seeds = .*/seeds = "${SEEDS}"/' ${GAIA_HOME}/config/config.toml
fi

if [ -n "$PERSISTENT_PEERS" ]; then
  sed -i 's/^persistent_peers = .*/persistent_peers = "${PERSISTENT_PEERS}"/' ${GAIA_HOME}/config/config.toml
fi

if [ -n "$PRIVATE_PEER_IDS" ]; then
  sed -i 's/^private_peer_ids = .*/private_peer_ids = "${PRIVATE_PEER_IDS}"/' ${GAIA_HOME}/config/config.toml
fi

gaiad start --home $GAIA_HOME
