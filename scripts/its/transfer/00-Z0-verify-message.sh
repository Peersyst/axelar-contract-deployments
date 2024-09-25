#!/bin/bash
RPC="http://devnet-amplifier.axelar.dev:26657"
CHAIN_ID="devnet-amplifier"
AVALANCHE_CHAIN="avalanche-fuji"
XRPL_EVM_CHAIN="xrpl-evm-sidechain"
XRPL_EVM_SOURCE_CHAIN_GATEWAY="axelar1cvc5u0z9fm6n5gcur3xqz4gmxj4j96vr6j5a099ygjedfpcmh5zqepykg4"

# To change this depending on the transaction
SOURCE_CHAIN_GATEWAY=$XRPL_EVM_SOURCE_CHAIN_GATEWAY
CHAIN_NAME=$XRPL_EVM_CHAIN
TRANSACTION_HASH="0xd9f647939a01f40916737b25056f0761d79f3b3f7852e40be71a6e3142a0bd4f"
EVENT_ID=2
MESSAGE_ID=$TRANSACTION_HASH-$EVENT_ID
DESTINATION_CHAIN=axelarnet
DESTINATION_ADDRESS="axelar10jzzmv5m7da7dn2xsfac0yqe7zamy34uedx3e28laq0p6f3f8dzqp649fp"
SOURCE_ADDRESS="0x3C5688654Dd334859C149A5005249828fd608284"
PAYLOAD_HASH="dd1325874d8283fc5c4ef7794cb452aa85217aebb3bd5711a6f0daddfaef1750"

axelard() {
  docker run --rm --platform linux/amd64 -v $PWD/.axelar:/home/axelard/.axelar axelarnet/axelar-core:v1.0.2 axelard $@
}

axelard tx wasm execute $SOURCE_CHAIN_GATEWAY '{"verify_messages":[{"cc_id":{"source_chain":"'"$CHAIN_NAME"'","message_id":"'"$MESSAGE_ID"'"},"destination_chain":"'"$DESTINATION_CHAIN"'","destination_address":"'"$DESTINATION_ADDRESS"'","source_address":"'"$SOURCE_ADDRESS"'","payload_hash":"'"$PAYLOAD_HASH"'"}]}' \
    --keyring-backend test  \
    --from wallet  \
    --gas 20000000 --gas-adjustment 1.5 --gas-prices 0.00005uamplifier \
    --chain-id $CHAIN_ID \
    --node $RPC

sleep 15

axelard tx wasm execute $SOURCE_CHAIN_GATEWAY '{"route_messages":[{"cc_id":{"source_chain":"'"$CHAIN_NAME"'","message_id":"'"$MESSAGE_ID"'"},"destination_chain":"'"$DESTINATION_CHAIN"'","destination_address":"'"$DESTINATION_ADDRESS"'","source_address":"'"$SOURCE_ADDRESS"'","payload_hash":"'"$PAYLOAD_HASH"'"}]}' \
    --keyring-backend test  \
    --from wallet  \
    --gas auto --gas-adjustment 1.5 --gas-prices 0.00005uamplifier \
    --chain-id $CHAIN_ID \
    --node $RPC