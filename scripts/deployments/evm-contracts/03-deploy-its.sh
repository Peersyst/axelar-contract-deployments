#!/bin/bash

SALT="xrpl-evm-sidechain"
NETWORK_ID=xrpl-evm-sidechain
ENVIRONMENT_ID=devnet-amplifier

echo "Deploying Operators..."
node evm/deploy-contract.js -c Operators -m create3 -n $NETWORK_ID -e $ENVIRONMENT_ID -y

echo "Deploying Gas Service..."
COLLECTOR_ADDRESS=$(jq .chains.\"$NETWORK_ID\".contracts.Operators.address axelar-chains-config/info/$ENVIRONMENT_ID.json)
node evm/deploy-upgradable.js -n $NETWORK_ID -e $ENVIRONMENT_ID -c AxelarGasService --args '{ "collector": '$COLLECTOR_ADDRESS' }' -s $SALT -y

echo "Deploying ITS..."
node evm/deploy-its.js  -n $NETWORK_ID -e $ENVIRONMENT_ID --proxySalt $SALT -m create2 -y