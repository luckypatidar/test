
function exportVariables(){

  # Organization information that you wish to build and deploy
  export NETWORK_NAME=$NETWORK_NAME
  export DOMAIN_OF_ORDERER=$DOMAIN_OF_ORDERER
  export ORDERER_MSP=$ORDERER_MSP
  export DOMAIN_OF_ORDERER_TWO=$DOMAIN_OF_ORDERER_TWO
  export DOMAIN_OF_ORDERER_THREE=$DOMAIN_OF_ORDERER_THREE

}

read -p "Orderer Domain: " DOMAIN_OF_ORDERER
read -p "Orderer Domain Two: " DOMAIN_OF_ORDERER_TWO
read -p "Orderer Domain Three: " DOMAIN_OF_ORDERER_THREE
read -p "Network Name: " NETWORK_NAME
read -p "ORDERER MSP NAME: " ORDERER_MSP


exportVariables

docker-compose up -d