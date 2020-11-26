#!/bin/bash

#variáveis
JBOSS_HOME="/opt/jboss"
export JAVA_HOME=/opt/java/
export PATH=$JAVA_HOME/bin:$PATH
DC=$( ip a | grep inet | grep 10 | awk '{print $2}' | cut -d '/' -f1 )
DC_PORT=9999
SERVER=$(hostname)
echo "Rundeck esta rodando no servidor: $SERVER"




stopSERVERGROUPS1(){
echo "Conectando vi CLI no $DC:$DC_PORT Parando o ServerGroup NAME_SERVER_GROUP1"
$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DC:$DC_PORT  --user=duilio --password=senha /server-group=NAME_SERVER_GROUP1:stop-servers

sleep 5

}

stopSERVERGROUPSMC(){
echo "Conectando vi CLI no $DC:$DC_PORT Parando o ServerGroup NAME_SERVER_GROUP2"
$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DC:$DC_PORT  --user=duilio --password=senha /server-group=NAME_SERVER_GROUP2:stop-servers

sleep 5

}

echo "Executando função do stop CLI"
stopSERVERGROUPS1
stopSERVERGROUPSMC

