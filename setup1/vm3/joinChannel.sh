function exportVariables(){
    export CORE_PEER_TLS_ENABLED=true
    export DOMAIN_OF_ORDERER=$DOMAIN_OF_ORDERER
    export DOMAIN_OF_ORGANIZATION=$DOMAIN_OF_ORGANIZATION
    export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem
    export PEER0_ORG_CA=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/ca.crt
    export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/
    export CHANNEL_NAME=$CHANNEL_NAME
    export NAME_OF_ORGANIZATION=$NAME_OF_ORGANIZATION
    export HOST_COMPUTER_IP_ADDRESS=$HOST_COMPUTER_IP_ADDRESS
    export ORDERER_COMPUTER_IP_ADDRESS=$ORDERER_COMPUTER_IP_ADDRESS
}

exportVariables

read -p "Orderer Domain: "  DOMAIN_OF_ORDERER
read -p "Organization Domain: " DOMAIN_OF_ORGANIZATION
read -p "Channel Name: " CHANNEL_NAME
read -p "Organization Name: "  NAME_OF_ORGANIZATION
read -p "Computer IP Address: " HOST_COMPUTER_IP_ADDRESS
read -p "Order Host IP Address: " ORDERER_COMPUTER_IP_ADDRESS



setGlobalsForPeer0Org() {
    export CORE_PEER_LOCALMSPID="${NAME_OF_ORGANIZATION}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}/msp
    export CORE_PEER_ADDRESS=${HOST_COMPUTER_IP_ADDRESS}:11051

}

setGlobalsForPeer1Org() {
    export CORE_PEER_LOCALMSPID="${NAME_OF_ORGANIZATION}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}/msp
    export CORE_PEER_ADDRESS=${HOST_COMPUTER_IP_ADDRESS}:12051

}

fetchChannelBlock() {
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0Org

    # Replace ${ORDERER_COMPUTER_IP_ADDRESS} with your orderer's vm IP address
    peer channel fetch 0 ./channel-artifacts/$CHANNEL_NAME.block -o ${ORDERER_COMPUTER_IP_ADDRESS}:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
}

# fetchChannelBlock

joinChannel() {
    setGlobalsForPeer0Org
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer1Org
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

}

# joinChannel

updateAnchorPeers() {
    setGlobalsForPeer0Org

    # Replace ${ORDERER_COMPUTER_IP_ADDRESS} with your orderer's vm IP address
    peer channel update -o ${ORDERER_COMPUTER_IP_ADDRESS}:7050 --ordererTLSHostnameOverride orderer.example.com \
        -c $CHANNEL_NAME -f ./../../artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

}

# updateAnchorPeers

fetchChannelBlock
joinChannel
updateAnchorPeers
