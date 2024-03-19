
function exportVariables(){

  # Organization information that you wish to build and deploy
  export NAME_OF_ORDERER=$NAME_OF_ORDERER
  export DOMAIN_OF_ORDERER=$DOMAIN_OF_ORDERER
  export HOST_COMPUTER_IP_ADDRESS=$HOST_COMPUTER_IP_ADDRESS
  export ORDERER_NAME_LOWERCASE=`echo "$NAME_OF_ORDERER" | tr '[:upper:]' '[:lower:]'`
}

read -p "Orderer Name: "  NAME_OF_ORDERER
read -p "Domain of Orderer: " DOMAIN_OF_ORDERER
read -p "Host computer Ip: " HOST_COMPUTER_IP_ADDRESS

exportVariables

# Start the certficate authority
cd create-certificate-with-ca
docker-compose up -d

./create-certificate-with-ca.sh