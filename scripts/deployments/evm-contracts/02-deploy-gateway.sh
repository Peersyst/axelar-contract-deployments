SALT="xrpl-evm-sidechain"
NETWORK_ID=xrpl-evm-sidechain
ENVIRONMENT_ID=devnet-amplifier

echo "Deploying Amplifier gateway..."
node evm/deploy-amplifier-gateway.js -e $ENVIRONMENT_ID -n $NETWORK_ID -s $SALT -y