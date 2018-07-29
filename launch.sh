#!/bin/bash -e

### Work in progress! ###
### Do not attempt to use this script, it probably won't work
###

usage() {
  echo "Usage:"
  echo "  launch.sh --help|-h"
  echo "  launch.sh [--gaiad_init][--image=<docker_image>][--moniker=<moniker>]"
  echo "  launch.sh [--image=<docker_image>][--host_config_dir=<host_config_dir][--genesis=<genesis file>][--priv_validator=<priv_validator.json][--seeds=<seeds>][--persistent_peers=<persistent_peer>][--private_peer_ids=<private_peer_ids>][--config_toml=<config.toml>]"
}

for i in "$@"
do
  case $i in
    -h|--help)
      HELP="true"
      shift # past argument
      ;;
    --gaiad_init)
      GAIAD_INIT="true"
      shift # past argument
      ;;
    --image=*)
      IMAGE="${i#*=}"
      shift # past argument
      ;;
    --host_config_dir=*)
      HOST_CONFIG_DIR="${i#*=}"
      shift # past argument
      ;;
    --genesis=*)
      GENESIS="${i#*=}"
      shift # past argument
      ;;
    --config_toml=*)
      CONFIG_TOML="${i#*=}"
      shift # past argument
      ;;
    --priv_validator=*)
      PRIV_VALIDATOR="${i#*=}"
      shift # past argument
      ;;
    --moniker=*)
      MONIKER="${i#*=}"
      shift # past argument
      ;;
    --seeds=*)
      SEEDS="${i#*=}"
      shift # past argument
      ;;
    --persistent_peers=*)
      PERSISTENT_PEERS="${i#*=}"
      shift # past argument
      ;;
    --private_peer_ids=*)
      PRIVATE_PEER_IDS="${i#*=}"
      shift # past argument
      ;;
    *)    # unknown option
      usage
      exit 1
      ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -n "$HELP" ]; then
  usage
  exit 0
fi

#: ${SEEDS="718145d422a823fd2a4e1e36e91b92bb0c4ddf8e@gaia-7000.coinculture.net:26656,5922bf29b48a18c2300b85cc53f424fce23927ab@67.207.73.206:26656,7c8b8fd03577cd4817f5be1f03d506f879df98d8@gaia-7000-seed1.interblock.io:26656,a28737ff02391a6e00a1d3b79befd57e68e8264c@gaia-7000-seed2.interblock.io:26656,987ffd26640cd03d08ed7e53b24dfaa7956e612d@gaia-7000-seed3.interblock.io:26656"}
: ${SEEDS=""}

: ${IMAGE="gaia"}
: ${PEERS=""}
: ${GENESIS=""}
: ${HOST_CONFIG_DIR="/root/.gaiad"}
: ${MONIKER="docker-default"}

: ${DETACH="-d"}
if [ -n "$GENESIS" ]; then
  GENESIS_VOLUME="-v $GENESIS:/tmp/genesis.json"
fi

if [ -n "$CONFIG_TOML" ]; then
  CONFIG_TOML_VOLUME="-v $CONFIG_TOML:/tmp/config.toml"
fi

if [ -n "$PRIV_VALIDATOR" ]; then
  PRIV_VOLUME="-v $PRIV_VALIDATOR:/tmp/priv_validator.json"
fi

ENV_FLAGS=""

if [ -n "$GAIAD_INIT" ]; then
  ENV_FLAGS="$ENV_FLAGS -e GAIAD_INIT=$GAIAD_INIT"
  DETACH=""
fi

if [ -n "$SEEDS" ]; then
  ENV_FLAGS="$ENV_FLAGS -e SEEDS=$SEEDS"
fi

if [ -n "$PERSISTENT_PEERS" ]; then
  ENV_FLAGS="$ENV_FLAGS -e PERSISTENT_PEERS=$PERSISTENT_PEERS"
fi

if [ -n "$PRIVATE_PEER_IDS" ]; then
  ENV_FLAGS="$ENV_FLAGS -e PRIVATE_PEER_IDS=$PRIVATE_PEER_IDS"
fi

echo "docker run $DETACH -p 26656-26657:26656-26657/tcp --name gaiad $GENESIS_VOLUME $CONFIG_TOML_VOLUME $PRIV_VOLUME -v $HOST_CONFIG_DIR:/data/gaiad -e MONIKER=$MONIKER $ENV_FLAGS --rm -it $IMAGE run-gaia.sh"

