# gaia-docker
Dockerfile for gaia

[Cosmos forum discussion](https://forum.cosmos.network/t/gaia-dockerfile/631)

### Prereqs
Install Docker

For Ubuntu distros: `sudo ./install-docker-ubuntu.sh`
For other distros see [Docker docs](https://docs.docker.com/install/)

### Build docker image
`sudo docker build --build-arg git_checkout_arg=v0.23.1 -t gaia .`

### Initialize gaiad
`sudo docker run -v /root/.gaiad:/root/.gaiad --rm -it gaia gaiad init --name my-node`

### Get genesis.json for latest testnet
`sudo curl -o /root/.gaiad/config/genesis.json https://raw.githubusercontent.com/cosmos/testnets/master/gaia-7004/genesis.json`

### Add seed nodes for latest testnet
`sudo sed -i 's/^seeds = .*/seeds = "718145d422a823fd2a4e1e36e91b92bb0c4ddf8e@gaia-testnet.coinculture.net:26656,5922bf29b48a18c2300b85cc53f424fce23927ab@67.207.73.206:26656,7c8b8fd03577cd4817f5be1f03d506f879df98d8@gaia-7000-seed1.interblock.io:26656,a28737ff02391a6e00a1d3b79befd57e68e8264c@gaia-7000-seed2.interblock.io:26656,987ffd26640cd03d08ed7e53b24dfaa7956e612d@gaia-7000-seed3.interblock.io:26656"/' /root/.gaiad/config/config.toml`

### Edit config.toml with appropriate settings
`sudo vi /root/.gaiad/config/config.toml`

### Start gaiad
`sudo docker run -d -p 26656-26657:26656-26657/tcp --name gaiad -v /root/.gaiad:/root/.gaiad --rm -it gaia gaiad start`

### Follow gaiad logs
`sudo docker logs -f gaiad`

### Open interactive bash shell inside container
`sudo docker exec -it gaiad bash`

### Stop gaiad
`sudo docker stop gaiad`
