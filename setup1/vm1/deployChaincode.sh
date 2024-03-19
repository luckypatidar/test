function exportVariables(){
    export CORE_PEER_TLS_ENABLED=true
    export DOMAIN_OF_ORDERER=$DOMAIN_OF_ORDERER
    export DOMAIN_OF_ORGANIZATION1=$DOMAIN_OF_ORGANIZATION1
    export DOMAIN_OF_ORGANIZATION2=$DOMAIN_OF_ORGANIZATION2
    export DOMAIN_OF_ORGANIZATION3=$DOMAIN_OF_ORGANIZATION3
    export ORDERER_CA=${PWD}/../vm4/crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem
    export PEER0_ORG1_CA=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/ca.crt
    export PEER0_ORG2_CA=${PWD}/../vm2/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION2}/peers/peer0.${DOMAIN_OF_ORGANIZATION2}/tls/ca.crt
    export PEER0_ORG3_CA=${PWD}/../vm3/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION3}/peers/peer0.${DOMAIN_OF_ORGANIZATION3}/tls/ca.crt
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
read -p "Organization1 Domain: " DOMAIN_OF_ORGANIZATION1
read -p "Organization2 Domain: " DOMAIN_OF_ORGANIZATION2
read -p "Organization3 Domain: " DOMAIN_OF_ORGANIZATION3
read -p "Channel Name: " CHANNEL_NAME
read -p "Organization Name: "  NAME_OF_ORGANIZATION
read -p "Computer IP Address: " HOST_COMPUTER_IP_ADDRESS
read -p "Order Host IP Address: " ORDERER_COMPUTER_IP_ADDRESS
read -p "CC NAME: " CC_NAME
read -p "CC PATH: " CC_PATH
setGlobalsForPeer0Org1() {
    export CORE_PEER_LOCALMSPID="${NAME_OF_ORGANIZATION}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION1}/users/Admin@${DOMAIN_OF_ORGANIZATION1}/msp
    export CORE_PEER_ADDRESS=${HOST_COMPUTER_IP_ADDRESS}:7051
}

setGlobalsForPeer1Org1() {
    export CORE_PEER_LOCALMSPID="${NAME_OF_ORGANIZATION}MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION1}/users/Admin@${DOMAIN_OF_ORGANIZATION1}/msp
    export CORE_PEER_ADDRESS=${HOST_COMPUTER_IP_ADDRESS}:8051

}

# setGlobalsForPeer0Org2() {
#     export CORE_PEER_LOCALMSPID="Org2MSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:9051

# }

# setGlobalsForPeer1Org2() {
#     export CORE_PEER_LOCALMSPID="Org2MSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/../../artifacts/channel/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
#     export CORE_PEER_ADDRESS=localhost:10051

# }

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
    setGlobalsForPeer0Org1
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.org1 ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org1 ===================== "

}

# installChaincode

queryInstalled() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled

approveForMyOrg1() {
    setGlobalsForPeer0Org1
    # set -x
    # Replace localhost with your orderer's vm IP address
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

# queryInstalled
# approveForMyOrg1

checkCommitReadyness() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
}

# commitChaincodeDefination

queryCommitted() {
    setGlobalsForPeer0Org1
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0Org1
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
         --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        --isInit -c '{"Args":[]}'

}

 # --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \

# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0Org1

    ## Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA   \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_ORG3_CA \
        -c '{"function": "createCar","Args":["Car-ABCDEEE", "Audi", "R8", "Red", "Sandip"]}'

    ## Init ledger
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.example.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME} \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
    #     --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
    #     -c '{"function": "initLedger","Args":[]}'

}

# chaincodeInvoke

chaincodeQuery() {
    setGlobalsForPeer0Org1

    # Query Car by Id
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR0"]}'
 
}

# chaincodeQuery

# Run this function if you add any new dependency in chaincode
# presetup

# packageChaincode
# installChaincode
# queryInstalled
# approveForMyOrg1
# checkCommitReadyness
# approveForMyOrg2
# checkCommitReadyness
# commitChaincodeDefination
# queryCommitted
# chaincodeInvokeInit
# sleep 5
# chaincodeInvoke
# sleep 3
# chaincodeQuery
