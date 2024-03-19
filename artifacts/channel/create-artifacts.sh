
chmod -R 0755 ./crypto-config
# Delete existing artifacts
rm -rf ./crypto-config
rm genesis.block mychannel.tx
rm -rf ../../channel-artifacts/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./mychannel.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for ${ORG1_NAME}MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./${ORG1_NAME}MSPanchors.tx -channelID $CHANNEL_NAME -asOrg ${ORG1_NAME}MSP

echo "#######    Generating anchor peer update for ${ORG2_NAME}MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./${ORG2_NAME}MSPanchors.tx -channelID $CHANNEL_NAME -asOrg ${ORG2_NAME}MSP

echo "#######    Generating anchor peer update for ${ORG3_NAME}MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./${ORG3_NAME}MSPanchors.tx -channelID $CHANNEL_NAME -asOrg ${ORG3_NAME}MSP