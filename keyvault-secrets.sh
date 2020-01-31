KV_NAME=kv-mydriving-DB
AzureSqlDB=mydrivingDB
SqlUser={your-sqluser}
SqlPassword={your-sqluser-password}
VmssObjectId={object-id-of-your-vmss}

az keyvault secret set --name SQL-SERVER --value $AzureSqlDB.database.windows.net --vault-name $KV_NAME
az keyvault secret set --name SQL-USER --value $SqlUser --vault-name $KV_NAME
az keyvault secret set --name SQL-PASSWORD --value $SqlPassword --vault-name $KV_NAME
az keyvault secret set --name SQL-DBNAME --value $AzureSqlDB --vault-name $KV_NAME

# set policy to access keys in your Key Vault
az keyvault set-policy -n $KV_NAME --key-permissions get --object-id $VmssObjectId
# set policy to access secrets in your Key Vault
az keyvault set-policy -n $KV_NAME --secret-permissions get --object-id $VmssObjectId
# set policy to access certs in your Key Vault
az keyvault set-policy -n $KV_NAME --certificate-permissions get --object-id $VmssObjectId