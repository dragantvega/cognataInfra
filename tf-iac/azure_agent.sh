#!/bin/bash


AGENT_PATH="./myagent"

rm -rf $AGENT_PATH
wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
mkdir $AGENT_PATH
cd $AGENT_PATH
tar xvfz ../vsts-agent-linux-x64-3.218.0.tar.gz
./config.sh --unattended --url https://dev.azure.com/dragantomasevic0768 --auth pat --token 7lsujeq3dvo762emxehy4tpa567j7k4t7srgnakdreoldwx7jqnq --pool default --agent myLinuxAgent --acceptTeeEula
./run.sh &