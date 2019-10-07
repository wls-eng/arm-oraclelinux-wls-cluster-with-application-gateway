#!/bin/bash

function usage()
{
  echo "$0 <resourceGroupName> <pathToCertificateFile> <certificatePassword>"
  ex: $0 test-rg /home/testuser/certificate.pfx Azure123456!
}

resourceGrpName=$1
pathToCertFile=$2
certPassword=$3

if [ "$#" -ne 3 ];
then
usage()
 exit 1
fi

if [ ! -f "$pathToCertFile" ];
then
 echo "Certificate file $pathToCertFile doesn't exist"
 echo "Please provide a valid certificate file in pfx format"
 exit 1
fi

az keyvault create --name "myKeyVault4Cert" --resource-group $resourceGrpName  --location southeastasia

az keyvault update --name "myKeyVault4Cert" --resource-group resourceGrpName --enabled-for-deployment "true"

az keyvault update --name "myKeyVault4Cert" --resource-group resourceGrpName --enabled-for-template-deployment "true"

az keyvault secret set --vault-name myKeyVault4Cert --encoding base64 --description text/plain --name myCertSecretData --file $pathToCertFile

az keyvault secret set --vault-name myKeyVault4Cert --name myCertSecretPassword --value $certPassword
