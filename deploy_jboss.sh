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

#Função de deploy, aplica pacotes no Jboss.

deploy_jboss(){

        $JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DC:$DC_PORT  --user=duilio --password=senha --command="deploy "$DEPLOY_ORIGEM/$DEPLOY_WAR_EAR" --all-server-groups";
        sleep 2
        echo "executando function de deploy do pacote, aplicando o pacote: $DEPLOY_WAR_EAR" 
}


if [ -z "$DEPLOY_WAR_EAR" ]; then
echo -e "Não a arquivos EAR e WAR para deploy"
                exit 1
else
sleep 1
        echo "Aplicando pacote $DEPLOY_WAR_EAR all-server-groups "
        deploy_jboss

        
fi
