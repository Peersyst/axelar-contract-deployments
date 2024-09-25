#!/bin/bash
XRPL_CHAIN="xrpl-evm-sidechain"
AVALANCHE_CHAIN="avalanche-fuji"

DESTINATION_CHAIN=$AVALANCHE_CHAIN
SESSION_ID="595"

node evm/gateway.js -n $DESTINATION_CHAIN --action submitProof --multisigSessionId $SESSION_ID