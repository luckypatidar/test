#!/bin/bash

# Set file paths
ORDERER_TLS_CERT_PATH="../../setup1/vm4/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
ORG1_MSP_DIR="../../setup1/vm1/crypto-config/peerOrganizations/org1.example.com/msp"
ORG2_MSP_DIR="../../setup1/vm2/crypto-config/peerOrganizations/org2.example.com/msp"
ORG3_MSP_DIR="../../setup1/vm3/crypto-config/peerOrganizations/org3.example.com/msp"

# Set hostnames and ports
ORDERER_HOST="orderer.example.com"
ORDERER_PORT="7050"
ORDERER2_HOST="orderer2.example.com"
ORDERER2_PORT="8050"
ORDERER3_HOST="orderer3.example.com"
ORDERER3_PORT="9050"
PEER0_ORG1_HOST="peer0.org1.example.com"
PEER0_ORG1_PORT="7051"
PEER0_ORG2_HOST="peer0.org2.example.com"
PEER0_ORG2_PORT="9051"
PEER0_ORG3_HOST="peer0.org3.example.com"
PEER0_ORG3_PORT="11051"
ORG1_NAME="Org1"
ORG2_NAME="Org2"
ORG3_NAME="Org3"

# Export variables
export ORDERER_TLS_CERT_PATH ORG1_MSP_DIR ORG2_MSP_DIR ORG3_MSP_DIR \
       ORDERER_HOST ORDERER_PORT ORDERER2_HOST ORDERER2_PORT ORDERER3_HOST ORDERER3_PORT \
       PEER0_ORG1_HOST PEER0_ORG1_PORT PEER0_ORG2_HOST PEER0_ORG2_PORT PEER0_ORG3_HOST PEER0_ORG3_PORT \
       ORG1_NAME ORG2_NAME ORG3_NAME


./create-arifacts.sh