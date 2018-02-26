FROM golang:1.10

RUN go get github.com/cosmos/gaia; \
    cd $GOPATH/src/github.com/cosmos/gaia; \
    make all; \
    git clone https://github.com/tendermint/testnets $HOME/testnets;

ENV GAIANET $HOME/testnets/gaia-3002/gaia

EXPOSE 46656
EXPOSE 46657
