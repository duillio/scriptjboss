#!/bin/bash

#variáveis
export JAVA_HOME=/opt/java/
export PATH=$JAVA_HOME/bin:$PATH
export HOMEDEPLOY=/opt/jboss/deploy/
PATHPACOTE="@option.PATHPACOTE@"

DEPLOY_ORIGEM=$HOMEDEPLOY$PATHPACOTE
DEPLOY_WAR_EAR=$(ls -lh "$DEPLOY_ORIGEM" | grep -E ".war|.ear" | awk '{print $9}')
DC=$( ip a | grep inet | grep 10 | awk '{print $2}' | cut -d '/' -f1 )
DC_PORT=9999
JBOSS_HOME="/opt/jboss"


#Função de Undeploy, remover pacotes do Jboss.
unDeploy (){
        for FILES in $DEPLOY_WAR_EAR; do
                $JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DC:$DC_PORT  --user=duilio --password=senha --command="undeploy "$FILES" --all-relevant-server-groups" 2>&1; sleep 5;  done
                echo Fazendo undeploy do pacote "$FILES"
}


if [ -z "$DEPLOY_WAR_EAR" ]; then
echo -e "Não a arquivos EAR e WAR para deploy"
                exit 1
else
unDeploy
sleep 5

fi
