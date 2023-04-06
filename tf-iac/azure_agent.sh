#!/bin/bash


AGENT_PATH="./myagent"
DATE=$(date +%s)

rm -rf $AGENT_PATH
wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
mkdir $AGENT_PATH
cd $AGENT_PATH
tar xvfz ../vsts-agent-linux-x64-3.218.0.tar.gz
./config.sh --unattended --url https://dev.azure.com/dragantomasevic0768 --auth pat --token $TOKEN --pool default --agent myLinuxAgent_$DATE --acceptTeeEula
echo "Sleeping 10 sec"
sleep 10
./run.sh &