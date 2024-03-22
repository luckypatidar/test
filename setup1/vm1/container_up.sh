
function exportVariables(){

  # Organization information that you wish to build and deploy
  export NAME_OF_ORGANIZATION=$NAME_OF_ORGANIZATION
  export DOMAIN_OF_ORGANIZATION=$DOMAIN_OF_ORGANIZATION
  export DB_NAME_ZERO=$DB_NAME_ZERO
  export DB_NAME_ONE=$DB_NAME_ONE
  export NETWORK_NAME=$NETWORK_NAME
  export DOMAIN_OF_ORGANIZATION_TWO=$DOMAIN_OF_ORGANIZATION_TWO
  export DOMAIN_OF_ORGANIZATION_THREE=$DOMAIN_OF_ORGANIZATION_THREE
  export DOMAIN_OF_ORDERER=$DOMAIN_OF_ORDERER
  export ORG_MSP=$ORG_MSP
  export COMPOSE_PROJECT_NAME=$COMPOSE_PROJECT_NAME
}

read -p "Organization Name: "  NAME_OF_ORGANIZATION
read -p "Organization one Domain: " DOMAIN_OF_ORGANIZATION
read -p "Organization two Domain: " DOMAIN_OF_ORGANIZATION_TWO
read -p "Organization three Domain: " DOMAIN_OF_ORGANIZATION_THREE
read -p "Orderer Domain: " DOMAIN_OF_ORDERER
read -p "DB Name 0: "  DB_NAME_ZERO
read -p "DB Name 1: "  DB_NAME_ONE
read -p "Network Name: " NETWORK_NAME
read -p "ORG MSP NAME: " ORG_MSP
read -p "COMPOSE Project Name: " COMPOSE_PROJECT_NAME


exportVariables

docker-compose up -d