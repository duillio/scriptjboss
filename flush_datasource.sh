#!/bin/bash

#variáveis
JBOSS_HOME="/opt/jboss"
export JAVA_HOME=/opt/java/
export PATH=$JAVA_HOME/bin:$PATH
PIDHC=$( ps aux | grep java | grep -v grep | grep org.jboss.as.host-controller |awk '{print $2}' )
NJVM=$(ls -lrt /opt/jboss/domain/servers/|tail -1|awk '{print $9}')
IPLOCAL=$( ip a | grep inet | grep 10 | awk '{print $2}' | cut -d '/' -f1 )
SERVER=$(hostname)
#DOM=$(netstat -napl|grep -E '$PIDHC|9999'|grep java|awk '{print $5}')
#DOM=$(netstat -napl|grep -E $PIDHC|grep 9999|grep java|awk '{print $5}'|head -1)
DOM=$(netstat -napl|grep -E $PIDHC|grep 9999|grep java|awk '{print $5}'|head -2|tail -1)
JBOSS_USERNAME='LOGIN'
JBOSS_PASSWORD='PASS'
JBOSS_LOG="/opt/jboss/domain/servers/$NJVM/log/"
NDSOURCE=$(cat $JBOSS_LOG/server.log|grep 'Unable to fill pool: java:jboss/datasources/'|tail -1|awk '{print $12}'|cut -c24-|sed 's/\.//g'|sed 's/\://g')

flushALL()
        {
                echo "Conectando vi CLI no $DOM executando flush datasource: $NDSOURCE"
                #$JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DOM  --user=$JBOSS_USERNAME --password=$JBOSS_PASSWORD /host=$SERVER/server=$NJVM/subsystem=datasources/data-source=$NDSOURCE/:flush-all-connection-in-pool
                RESULT=$($JBOSS_HOME/bin/jboss-cli.sh --connect --controller=$DOM  --user=$JBOSS_USERNAME --password=$JBOSS_PASSWORD /host=$SERVER/server=$NJVM/subsystem=datasources/data-source=$NDSOURCE/:flush-all-connection-in-pool)

                sleep 2

        }

echo "Executando Flush datasource: $NDSOURCE, da JVM: $NJVM"

flushALL
echo $RESULT |cut -c17-23
echo $RESULT
RETORNO=$(echo $RESULT |cut -c17-23)
if [ -z $RETORNO ];
         then
                echo "O Flush falhou, por favor verificar o datasource: $NDSOURCE da jvm: $NJVM"



                    else
                echo "Flush realizado com sucesso"



fi
