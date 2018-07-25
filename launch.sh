#!/bin/bash -e

set -x

usage() {
  echo "Usage:"
  echo "  launch.sh --help"
  echo "  launch.sh [--gaiad_init][--image=<docker_image>]"
  echo "  launch.sh [--image=<docker_image>][--host_config_dir=<host_config_dir][--genesis=<genesis file>][--priv_validator=<priv_validator.json][--moniker=<moniker>][--seeds=<seeds>][--persistent_peers=<persistent_peer>][--private_peer_ids=<private_peer_ids>][--config_toml=<config.toml>]"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -h|--help)
      HELP="true"
      shift # past argument
      ;;
    --gaiad_init)
      GAIAD_INIT="true"
      shift # past argument
      ;;
    --image)
      IMAGE="$2"
      shift # past argument
      shift # past value
      ;;
    --host_config_dir)
      HOST_CONFIG_DIR="$2"
      shift # past argument
      shift # past value
      ;;
    --genesis)
      GENESIS="$2"
      shift # past argument
      shift # past value
      ;;
    --config_toml)
      CONFIG_TOML="$2"
      shift # past argument
      shift # past value
      ;;
    --priv_validator)
      PRIV_VALIDATOR="$2"
      shift # past argument
      shift # past value
      ;;
    --moniker)
      MONIKER="$2"
      shift # past argument
      shift # past value
      ;;
    --seeds)
      SEEDS="$2"
      shift # past argument
      ;;
    --persistent_peers)
      PERSISTENT_PEERS="$2"
      shift # past argument
      ;;
    --private_peer_ids)
      PRIVATE_PEER_IDS="$2"
      shift # past argument
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -n "$HELP" ]; then
  echo "us"
  usage
  exit 0
fi

#: ${SEEDS="718145d422a823fd2a4e1e36e91b92bb0c4ddf8e@gaia-7000.coinculture.net:26656,5922bf29b48a18c2300b85cc53f424fce23927ab@67.207.73.206:26656,7c8b8fd03577cd4817f5be1f03d506f879df98d8@gaia-7000-seed1.interblock.io:26656,a28737ff02391a6e00a1d3b79befd57e68e8264c@gaia-7000-seed2.interblock.io:26656,987ffd26640cd03d08ed7e53b24dfaa7956e612d@gaia-7000-seed3.interblock.io:26656"}
: ${SEEDS=""}

: ${IMAGE="gaia"}
: ${PEERS=""}
: ${GENESIS=""}
: ${HOST_CONFIG_DIR="gaiad"}
: ${MONIKER="docker-default"}

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


echo " docker run --name gaiad $GENESIS_VOLUME $CONFIG_TOML_VOLUME $PRIV_VOLUME -v $HOST_CONFIG_DIR:/etc/gaiad -e MONIKER=$MONIKER $ENV_FLAGS --rm -it $IMAGE run-gaia.sh"

docker run --name gaiad $GENESIS_VOLUME $CONFIG_TOML_VOLUME $PRIV_VOLUME -v $HOST_CONFIG_DIR:/etc/gaiad -e MONIKER=$MONIKER $ENV_FLAGS --rm -it $IMAGE run-gaia.sh

