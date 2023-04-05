#!/bin/bash


AGENT_PATH="./myagent"

rm -rf $AGENT_PATH
wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
mkdir $AGENT_PATH
cd $AGENT_PATH
tar xvfz ../vsts-agent-linux-x64-3.218.0.tar.gz
./config.sh --unattended --url https://dev.azure.com/dragantomasevic --auth pat --token jcazkgfv2qtti6twxaiutn6rwv3nzbc3su3kpej3pmo2gdiqogqq --pool default --agent myLinuxAgent --acceptTeeEula
./run.sh