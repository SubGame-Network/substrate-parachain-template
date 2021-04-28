#!/usr/bin/env bash
set -e

if [ ! -f ./target/release/subgame-collator ] || [ ${cargoBuildEverytime} == true ]; then
    cargo build --release
fi

if [ ! -d ./resources ]; then
    mkdir ./resources
fi

./target/release/subgame-collator export-genesis-state --parachain-id ${parachainid} > ./resources/para-genesis
./target/release/subgame-collator export-genesis-wasm > ./resources/para-wasm

./target/release/subgame-collator \
    --collator \
    --port 30333 \
    --ws-port 9944 \
    --rpc-port 9933 \
    --node-key ${nodeKey} \
    --rpc-external \
    --ws-external \
    --rpc-methods=Unsafe \
    --rpc-cors=all \
    --pruning=archive \
    --parachain-id ${parachainid} \
    --base-path ./storage \
    -- \
    --execution wasm \
    --chain rococo