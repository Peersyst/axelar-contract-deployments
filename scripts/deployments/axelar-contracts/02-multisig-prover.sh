export VERIFIER_CODE_ID=626
export MY_WALLET_ADDRESS="axelar10vr48fv67jg3tfqzfzy2x7umtyrl6agmhzu8tw"
export MY_SOURCE_CHAIN_GATEWAY_ADDRESS="0x48CF6E93C4C1b014F719Db2aeF049AA86A255fE2"
export CHAIN_NAME="xrpl-evm-sidechain"

export GATEWAY_CODE_ID=616
export MY_VERIFIER_ADDRESS="axelar1xcw4406vjv7dha4zqqvpu74xytkeafnh5l398e9wa3nf42tzqlnsfw7fqm"

export PROVER_CODE_ID=618
export MY_GATEWAY_ADDRESS="axelar1cvc5u0z9fm6n5gcur3xqz4gmxj4j96vr6j5a099ygjedfpcmh5zqepykg4"
export DOMAIN_SEPARATOR="069231ee16189bae59549ea7f4e2141d984279b453d767a618f80088ab2e191c"
export MY_CHAIN_ID=1440002

axelard tx wasm instantiate $PROVER_CODE_ID \
    '{
        "admin_address": "'"$MY_WALLET_ADDRESS"'",
        "governance_address": "axelar1zlr7e5qf3sz7yf890rkh9tcnu87234k6k7ytd9",
        "gateway_address": "'"$MY_GATEWAY_ADDRESS"'",
        "multisig_address": "axelar19jxy26z0qnnspa45y5nru0l5rmy9d637z5km2ndjxthfxf5qaswst9290r",
        "coordinator_address":"axelar1m2498n4h2tskcsmssjnzswl5e6eflmqnh487ds47yxyu6y5h4zuqr9zk4g",
        "service_registry_address":"axelar1c9fkszt5lq34vvvlat3fxj6yv7ejtqapz04e97vtc9m5z9cwnamq8zjlhz",
        "voting_verifier_address": "'"$MY_VERIFIER_ADDRESS"'",
        "signing_threshold": ["1","1"],
        "service_name": "validators",
        "chain_name":"'"$CHAIN_NAME"'",
        "verifier_set_diff_threshold": 1,
        "encoder": "abi",
        "key_type": "ecdsa",
        "domain_separator": "'"$DOMAIN_SEPARATOR"'"
    }' \
    --keyring-backend test \
    --from wallet \
    --gas auto --gas-adjustment 1.5 --gas-prices 0.00005uamplifier\
    --chain-id devnet-amplifier \
    --node http://devnet-amplifier.axelar.dev:26657 \
    --label $CHAIN_NAME-prover  \
    --admin $MY_WALLET_ADDRESS
