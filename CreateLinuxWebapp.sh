#!/bin/bash
#
# Dokcercon 2017 Linux Web App Demo
# Author: Lukasz Stempniewicz
#
ESC_SEQ="\x1b["
NC=$ESC_SEQ"39;49;00m"
RED=$ESC_SEQ"31;01m"
GREEN=$ESC_SEQ"32;01m"
YELLOW=$ESC_SEQ"33;01m"
BLUE=$ESC_SEQ"34;01m"
MAGENTA=$ESC_SEQ"35;01m"
CYAN=$ESC_SEQ"36;01m"

printf "${CYAN}Let's create a webapp on linux!${NC}\n"

printf "${CYAN}Please provide the following (Or press enter for defaults)${NC}\n\n"

printf "Resource group name:"
read rg
if [[ -z $rg ]]; then
  printf "${YELLOW}Empty${NC} resource group, creating random name\n"
  rg=RGDockerCon$RANDOM
fi
printf "$rg sounds fantastic!\n\n"

printf "Location, Please enter westus, westeurope, or southeastasia:"
read location
if [[ -z $location ]]; then
  printf "${YELLOW}Warning!${NC} Empty location, using \"westus\"\n"
  location="westus"
fi
printf "Using $location\n\n"

printf "App Service Plan name:"
read aspname
if [[ -z $aspname ]]; then
  printf "${YELLOW}Warning!${NC} Empty App Service Plan name, creating random name\n"
  aspname=ASPDockerCon$RANDOM
fi
printf "Using $aspname\n\n"

printf "App service plan sku(Basic: \"B1\", \"B2\", \"B3\", Standard:\"S1\", \"S2\", \"S3\"):" 
read sku
if [[ -z $sku ]]; then
  printf "${YELLOW}Warning!${NC}Empty sku. Using default sku.\n"
  sku=S1
fi
printf "Using $sku\n\n"

printf "Webapp name:"
read webapp
if [[ -z $webapp ]]; then
  printf "${YELLOW}Warning!${NC} Empty Web App name, creating random name\n"
  webapp=LinuxWebApp$RANDOM$RANDOM$RANDOM
fi
printf "Using $webapp\n\n"

read -r -p "Do you like pokemon battles?? [y/N]:"  response

printf "Using current account:\n"
az account show
printf "Running:\n   az group create -l \"$location\" -n $rg\n" 
az group create -l $location -n $rg
printf "Running:\n   az appservice plan create -n $aspname -g $rg --sku $sku --is-linux\n"
az appservice plan create -n $aspname -g $rg --sku $sku --is-linux
printf "Running:\n   az appservice web create -g $rg -n $webapp -p $aspname\n"
az appservice web create -g $rg -n $webapp -p $aspname

printf "${GREEN}Webapp created!${NC} URL:${CYAN}$webapp.azurewebsites.net${NC}\n\n"

configureForPokemonShowdown () {
  dockercustomimage="hasjo/pokemon-showdown" 
  printf "Running az appservice web config container update --docker-custom-image-name $dockercustomimage -g $rg -n $webapp -p $aspname\n" 
  az appservice web config container update --docker-custom-image-name $dockercustomimage -g $rg -n $webapp -p $aspname 
  printf "${MAGENTA} Pokemon showdown has been installed on $webapp.azurewebsites.net${NC}\n"
  printf "${MAGENTA} It may take up to two minutes to initialize${NC}\n"
  printf "${CYAN}Please copy url into any browser to start.${NC}\n\n"
}

case "$response" in
    [yY][eE][sS]|[yY]) 
        configureForPokemonShowdown 
        ;;
    *)
        # no-op  
        ;;
esac
