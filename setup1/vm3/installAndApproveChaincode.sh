function exportVariables(){
    export CORE_PEER_TLS_ENABLED=true
    export DOMAIN_OF_ORDERER=$DOMAIN_OF_ORDERER
    export DOMAIN_OF_ORGANIZATION=$DOMAIN_OF_ORGANIZATION
    export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem
    export PEER0_ORG3_CA=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/ca.crt
    export FABRIC_CFG_PATH=${PWD}/../../artifacts/channel/config/
    export CHANNEL_NAME=$CHANNEL_NAME
    export NAME_OF_ORGANIZATION=$NAME_OF_ORGANIZATION
    export HOST_COMPUTER_IP_ADDRESS=$HOST_COMPUTER_IP_ADDRESS
    export ORDERER_COMPUTER_IP_ADDRESS=$ORDERER_COMPUTER_IP_ADDRESS
    export CC_NAME=$CC_NAME
    export CC_PATH=$CC_PATH
}

exportVariables

read -p "Orderer Domain: "  DOMAIN_OF_ORDERER
read -p "Organization Domain: " DOMAIN_OF_ORGANIZATION
read -p "Channel Name: " CHANNEL_NAME
read -p "Organization Name: "  NAME_OF_ORGANIZATION
read -p "Computer IP Address: " HOST_COMPUTER_IP_ADDRESS
read -p "Order Host IP Address: " ORDERER_COMPUTER_IP_ADDRESS
read -p "CC NAME: " CC_NAME
read -p "CC PATH: " CC_PATH

setGlobalsForPeer0Org3() {
    export CORE_PEER_LOCALMSPID="${NAME_OF_ORGANIZATION}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}/msp
    export CORE_PEER_ADDRESS=${HOST_COMPUTER_IP_ADDRESS}:11051

}

setGlobalsForPeer1Org3() {
    export CORE_PEER_LOCALMSPID="${NAME_OF_ORGANIZATION}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}/msp
    export CORE_PEER_ADDRESS=${HOST_COMPUTER_IP_ADDRESS}:12051

}

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./../../artifacts/src/github.com/fabcar/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup

CHANNEL_NAME=${CHANNEL_NAME}
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH=${CC_PATH}
CC_NAME=${CC_NAME}


packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0Org3
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.org3 ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0Org3
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org3 ===================== "

}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0Org3
    peer lifecycle chaincode queryinstalled >&log.txt

    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org3 on channel ===================== "
}

# queryInstalled

approveForMyOrg3() {
    setGlobalsForPeer0Org3

    peer lifecycle chaincode approveformyorg -o ${ORDERER_COMPUTER_IP_ADDRESS}:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from org 3 ===================== "
}
# queryInstalled
# approveForMyOrg3

checkCommitReadyness() {

    setGlobalsForPeer0Org3
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses ${ORDERER_COMPUTER_IP_ADDRESS}:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 3 ===================== "
}

# checkCommitReadyness
