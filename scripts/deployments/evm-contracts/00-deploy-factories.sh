SALT="xrpl-evm-sidechain"
NETWORK_ID=xrpl-evm-sidechain
ENVIRONMENT_ID=devnet-amplifier

echo "Deploying contract factories..."
node evm/deploy-contract.js -c ConstAddressDeployer -m create -n $NETWORK_ID -e $ENVIRONMENT_ID -y
node evm/deploy-contract.js -c Create3Deployer -m create2 -n $NETWORK_ID -e $ENVIRONMENT_ID -y


