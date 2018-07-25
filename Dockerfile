FROM golang:1.10

ARG git_checkout_arg

RUN go get github.com/cosmos/cosmos-sdk; \
    cd $GOPATH/src/github.com/cosmos/cosmos-sdk; \
    git checkout $git_checkout_arg; \
    make; \
    git checkout master;

COPY src/run-gaia.sh /usr/local/bin

EXPOSE 26656
EXPOSE 26657
