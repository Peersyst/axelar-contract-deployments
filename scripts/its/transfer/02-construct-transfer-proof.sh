#!/bin/bash

RPC="http://devnet-amplifier.axelar.dev:26657"
CHAIN_ID="devnet-amplifier"
SOURCE_CHAIN="axelarnet"
XRPL_EVM_MULTISIG_PROVER="axelar19pu8hfnwgc0vjhadmvmgz3w4d2g7d7qlg6jjky9y2mf8ea4vf4usj6ramg"
AVALANCHE_PROVER="axelar1p22kz5jr7a9ruu8ypg40smual0uagl64dwvz5xt042vu8fa7l7dsl3wx8q"

# To change this depending on the transaction
DESTINATION_CHAIN_MULTISIG_PROVER=$AVALANCHE_PROVER
MESSAGE_ID="0x000000000000000000000000000000000000000000000000000000000032163b-17"

axelard() {
  docker run --rm --platform linux/amd64 -v $PWD/.axelar:/home/axelard/.axelar axelarnet/axelar-core:v1.0.2 axelard $@
}

axelard tx wasm execute $DESTINATION_CHAIN_MULTISIG_PROVER '{"construct_proof":[{"source_chain":"'"$SOURCE_CHAIN"'","message_id":"'"$MESSAGE_ID"'"}]}' \
    --keyring-backend test  \
    --from wallet  \
    --gas auto --gas-adjustment 1.5 --gas-prices 0.00005uamplifier \
    --chain-id $CHAIN_ID \
    --node $RPC