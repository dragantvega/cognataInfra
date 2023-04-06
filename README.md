# Cognata assignment
## List of instructions
- I have used my own free trial account on Azure to run everything
- terraform bucket for tfstate needs to be created manually on Azure before running anything with terraform.
- Plain text passwords were used to avoid time waste. Same for variables - many things are hardcoded. Exception is Azure agent token that I will provide, which is entered as user input when running `terraform apply`
- Since free Azure account is used not all SKU sizes are available on all Azure locations. This means sometimes we dont have a SKU that we requested. To list available SKUs for account I use command:
     > az vm list-skus  --all --output table --location uksouth --resource virtualMachines|grep -v NotAvailableForSubscription
- Azure Devops connections to Github are created manually. Azure Devops agent is created from Azure infrastructure.
- Angular application will be built and deployed when Azure Pipeline is started. Hello world type application will be running on Azure public ip on http port 4200 depending on random public IP assigned. This IP can be fetched from Azure VM settings. There are more elegant ways to do this with DNS, or caching terraform output.
- How to start(if terraform state bucket is already created):
     - cd to tf-iac directory 
     - terraform init
     - terraform apply
     - in Azure Devops run the pipeline
     - when done go to application hosted at: http://publicIP:4200 