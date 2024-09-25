export VERIFIER_CODE_ID=626
export MY_WALLET_ADDRESS="axelar10vr48fv67jg3tfqzfzy2x7umtyrl6agmhzu8tw"
export MY_SOURCE_CHAIN_GATEWAY_ADDRESS="0x48CF6E93C4C1b014F719Db2aeF049AA86A255fE2"
export CHAIN_NAME="xrpl-evm-sidechain"

export GATEWAY_CODE_ID=616
export MY_VERIFIER_ADDRESS="axelar1xcw4406vjv7dha4zqqvpu74xytkeafnh5l398e9wa3nf42tzqlnsfw7fqm"

axelard tx wasm instantiate $GATEWAY_CODE_ID \
    '{
        "verifier_address": "'"$MY_VERIFIER_ADDRESS"'",
        "router_address": "axelar14jjdxqhuxk803e9pq64w4fgf385y86xxhkpzswe9crmu6vxycezst0zq8y"
    }' \
    --keyring-backend test \
    --from wallet \
    --gas auto --gas-adjustment 1.5 --gas-prices 0.00005uamplifier\
    --chain-id devnet-amplifier \
    --node http://devnet-amplifier.axelar.dev:26657 \
    --label $CHAIN_NAME-gateway \
    --admin $MY_WALLET_ADDRESS
