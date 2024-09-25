export VERIFIER_CODE_ID=626
export MY_WALLET_ADDRESS="axelar10vr48fv67jg3tfqzfzy2x7umtyrl6agmhzu8tw"
export MY_SOURCE_CHAIN_GATEWAY_ADDRESS="0x48CF6E93C4C1b014F719Db2aeF049AA86A255fE2"
export CHAIN_NAME="xrpl-evm-sidechain"

axelard tx wasm instantiate $VERIFIER_CODE_ID \
    '{
        "governance_address": "axelar1zlr7e5qf3sz7yf890rkh9tcnu87234k6k7ytd9",
        "service_registry_address":"axelar1c9fkszt5lq34vvvlat3fxj6yv7ejtqapz04e97vtc9m5z9cwnamq8zjlhz",
        "service_name":"validators",
        "source_gateway_address":"'"$MY_SOURCE_CHAIN_GATEWAY_ADDRESS"'",
        "voting_threshold":["1","1"],
        "block_expiry":"10",
        "confirmation_height":1,
        "source_chain":"'"$CHAIN_NAME"'",
        "rewards_address":"axelar1vaj9sfzc3z0gpel90wu4ljutncutv0wuhvvwfsh30rqxq422z89qnd989l",
        "msg_id_format":"hex_tx_hash_and_event_index",
        "address_format": "eip55"
    }' \
    --keyring-backend test \
    --from wallet \
    --gas auto --gas-adjustment 1.5 --gas-prices 0.00005uamplifier\
    --chain-id devnet-amplifier \
    --node http://devnet-amplifier.axelar.dev:26657 \
    --label $CHAIN_NAME-voting-verifier \
    --admin $MY_WALLET_ADDRESS
