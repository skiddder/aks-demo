az keyvault secret set --name SQL-SERVER --value {your-azure-sql-db}.database.windows.net --vault-name <your-kevault-name>
az keyvault secret set --name SQL-USER --value {your-sqluser} --vault-name <your-kevault-name>
az keyvault secret set --name SQL-PASSWORD --value {your-sqluser-password} --vault-name <your-kevault-name>
az keyvault secret set --name SQL-DBNAME --value mydrivingDB --vault-name <your-kevault-name>