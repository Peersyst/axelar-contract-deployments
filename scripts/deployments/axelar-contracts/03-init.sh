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

export MULTISIG_PROVER_ADDRESS="axelar19pu8hfnwgc0vjhadmvmgz3w4d2g7d7qlg6jjky9y2mf8ea4vf4usj6ramg"

axelard tx wasm execute $MULTISIG_PROVER_ADDRESS \
  '"update_verifier_set"' \
    --node http://devnet-amplifier.axelar.dev:26657 \
    --from wallet \
    --keyring-backend test \
    --gas auto --gas-adjustment 1.5 --gas-prices 0.007uamplifier \
    --chain-id devnet-amplifier
