createCretificateForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}

  fabric-ca-client enroll -u https://admin:adminpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/${HOST_COMPUTER_IP_ADDRESS}-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/config.yaml

  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/${DOMAIN_OF_ORDERER}

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp --csr.hosts orderer.${DOMAIN_OF_ORDERER} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls --enrollment.profile tls --csr.hosts orderer.${DOMAIN_OF_ORDERER} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem

  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}

  echo
  echo "## Generate the orderer2 msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/msp --csr.hosts orderer2.${DOMAIN_OF_ORDERER} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/msp/config.yaml

  echo
  echo "## Generate the orderer2-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls --enrollment.profile tls --csr.hosts orderer2.${DOMAIN_OF_ORDERER} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer2.${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem

  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}

  echo
  echo "## Generate the orderer3 msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/msp --csr.hosts orderer3.${DOMAIN_OF_ORDERER} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/msp/config.yaml

  echo
  echo "## Generate the orderer3-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls --enrollment.profile tls --csr.hosts orderer3.${DOMAIN_OF_ORDERER} --csr.hosts ${HOST_COMPUTER_IP_ADDRESS} --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/orderers/orderer3.${DOMAIN_OF_ORDERER}/msp/tlscacerts/tlsca.${DOMAIN_OF_ORDERER}-cert.pem
  # ---------------------------------------------------------------------------

  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/users
  mkdir -p ../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/users/Admin@${DOMAIN_OF_ORDERER}

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@${HOST_COMPUTER_IP_ADDRESS}:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/users/Admin@${DOMAIN_OF_ORDERER}/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  cp ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/${DOMAIN_OF_ORDERER}/users/Admin@${DOMAIN_OF_ORDERER}/msp/config.yaml

}

createCretificateForOrderer