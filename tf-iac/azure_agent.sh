#!/bin/bash


AGENT_PATH="./myagent"

rm -rf $AGENT_PATH
wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
mkdir $AGENT_PATH
cd $AGENT_PATH
tar xvfz ../vsts-agent-linux-x64-3.218.0.tar.gz
./config.sh --unattended --url https://dev.azure.com/dragantomasevic0768 --auth pat --token $TOKEN --pool default --agent myLinuxAgent --acceptTeeEula
sleep 5
./run.sh &