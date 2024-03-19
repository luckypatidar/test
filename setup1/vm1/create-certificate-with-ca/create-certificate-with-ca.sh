createcertificatesForOrg() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/

  fabric-ca-client enroll -u https://admin:adminpw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-7054-ca-${ORGANIZATION_NAME_LOWERCASE}-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-7054-ca-${ORGANIZATION_NAME_LOWERCASE}-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-7054-ca-${ORGANIZATION_NAME_LOWERCASE}-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-7054-ca-${ORGANIZATION_NAME_LOWERCASE}-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.${DOMAIN_OF_ORGANIZATION} --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.${DOMAIN_OF_ORGANIZATION} --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.${DOMAIN_OF_ORGANIZATION} --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.${DOMAIN_OF_ORGANIZATION} --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} -M ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/msp --csr.hosts peer0.${DOMAIN_OF_ORGANIZATION} --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} -M ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls --enrollment.profile tls --csr.hosts peer0.${DOMAIN_OF_ORGANIZATION} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/tlsca/tlsca.${DOMAIN_OF_ORGANIZATION}-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/ca
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer0.${DOMAIN_OF_ORGANIZATION}/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/ca/ca.${DOMAIN_OF_ORGANIZATION}-cert.pem

  # ------------------------------------------------------------------------------------------------

  # Peer1

  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} -M ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/msp --csr.hosts peer1.${DOMAIN_OF_ORGANIZATION} --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/msp/config.yaml

  echo
  echo "## Generate the peer1-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} -M ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls --enrollment.profile tls --csr.hosts peer1.${DOMAIN_OF_ORGANIZATION} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/peers/peer1.${DOMAIN_OF_ORGANIZATION}/tls/server.key

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users
  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/User1@${DOMAIN_OF_ORGANIZATION}

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} -M ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/User1@${DOMAIN_OF_ORGANIZATION}/msp --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://org1admin:org1adminpw@${HOST_COMPUTER_IP_ADDRESS}:7054 --caname ca.${DOMAIN_OF_ORGANIZATION} -M ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}/msp --tls.certfiles ${PWD}/fabric-ca/${ORGANIZATION_NAME_LOWERCASE}/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/${DOMAIN_OF_ORGANIZATION}/users/Admin@${DOMAIN_OF_ORGANIZATION}/msp/config.yaml

}

createcertificatesForOrg
