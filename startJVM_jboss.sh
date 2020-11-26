#!/bin/bash

#variáveis
JBOSS_HOME="/opt/jboss"
export JAVA_HOME=/opt/java/
export PATH=$JAVA_HOME/bin:$PATH
DC=$( ip a | grep inet | grep 10 | awk '{print $2}' | cut -d '/' -f1 )
DC_PORT=9999
SERVER=$(hostname)
echo "Rundeck esta rodando no servidor: $SERVER"



startSERVERGROUPS1(){
echo "Conectando na CLI $DC:$DC_PORT Subindo ServerGroup NAME_SERVER_GROUP1"
$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DC:$DC_PORT  --user=duilio --password=senha /server-group=NAME_SERVER_GROUP1:start-servers

sleep 5

}

startSERVERGROUPSMC(){
echo "Conectando na CLI $DC:$DC_PORT Subindo ServerGroup NAME_SERVER_GROUP2"
$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DC:$DC_PORT  --user=duilio --password=senha /server-group=NAME_SERVER_GROUP2:start-servers

sleep 5

}

echo "Executando função do start CLI"
startSERVERGROUPS1
startSERVERGROUPSMC

