# Cognata assignment
## List of instructions on how to test assignment
If we have clean state(start from scratch): 
1. create on Azure: storage account and storage container
2. save the names of those resources and edit them in "backend" section of main.tf
3. run `terraform init`
4. run `terraform apply` - when asked for token I will give this beforehand, and confirm to create resources
5. while infra is being created, go to Azure DevOps and create new pipeline while linking it to GitHub repository named: dragantomasevic/cognataInfra
6. when infra finishes creation Azure agent should be running in Azure DevOps ready to run jobs.
7. Run the Azure Pipeline, when its done PUBLIC IP ADDRESS will be in application log. 
8. Go to http://PUBLIC_IP:4200 to visit Angular app being deployed (it needs minute or two to run)

## Description of repositories
- https://github.com/dragantvega/cognataInfra - public infrastructure repo (current repo) where all recipes are being held
- https://github.com/dragantvega/cognatatestapp - private repo to hold node application

## Description of architecture
Terraform will create virtual machine in Azure with all needed resources(network, disk etc.). When machine is created, provisioners on machine will:
- install OS level packages using `install.sh` script. Here we will install **Ansible**. 
- Ansible will run playbook to install docker, docker-compose and set current user to correct docker groups
- Installer will run azure build agent install script and connect to Azure

Azure Pipeline will be ready to run tasks. After running Azure pipeline following happens:
- Checkout of node application private repository
- Build docker image from that repository
- switch to Angular repository
- Build docker image to build Angular application, Angular application from within Dockerfile is built using Make tool from Makefile
- when both images are built application is run with docker-compose


## Some assumptions
- I have used my own free trial account on Azure to run everything
- terraform bucket for tfstate needs to be created manually on Azure before running anything with terraform.
- Plain text passwords were used to avoid time waste. Same for variables - many things are hardcoded. Exception is Azure agent token that I will provide, which is entered as user input when running `terraform apply`. I am aware in real world this is bad practice.
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