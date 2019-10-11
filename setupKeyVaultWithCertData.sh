#!/bin/bash

function usage()
{
  echo "$0 <resourceGroupName> <keyVaultName> <pathToCertificateFile> <certificatePassword>"
  echo "ex: $0 test-rg myKeyVault4Cert /home/testuser/certificate.pfx Azure123456!"
  exit 1
}

resourceGrpName=$1
keyVaultName=$2
pathToCertFile=$3
certPassword=$4

if [ "$#" -ne 4 ];
then
  usage
fi

if [ ! -f "$pathToCertFile" ];
then
 echo "Certificate file $pathToCertFile doesn't exist"
 echo "Please provide a valid certificate file in pfx format"
 exit 1
fi

echo "Creating Key Vault..."
az keyvault create --name $keyVaultName --resource-group $resourceGrpName  --location southeastasia

echo "Enabling Deployment on Key Vault ..."
az keyvault update --name $keyVaultName --resource-group $resourceGrpName --enabled-for-deployment "true"

echo "Enabling Template Deployment on Key Vault ..."
az keyvault update --name $keyVaultName --resource-group $resourceGrpName --enabled-for-template-deployment "true"

echo "Setting Secret myCertSecretData on Key Vault ..."
az keyvault secret set --vault-name $keyVaultName --encoding base64 --description text/plain --name myCertSecretData --file $pathToCertFile

echo "Setting Secret myCertSecretPassword on Key Vault ..."
az keyvault secret set --vault-name $keyVaultName --name myCertSecretPassword --value $certPassword

echo "Completed."
