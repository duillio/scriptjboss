#!/bin/bash

       #Criar /opt/jboss/backup/ 

        nomeDir=`date +%d%m%Y`

        dirOld=`date --date="yesterday" +%d%m%Y`

        if [ -d "/opt/jboss/backup/$nomeDir" ]; then

                        rm -rf /opt/jboss/backup/$dirOld

                                else

                                        mkdir /opt/jboss/backup/$nomeDir

        fi

 

        #Rotina de criação dos arquivos filtrados contendo o nome do EAR e a sua respectiva Hash.

        JBOSSCONTENT="/opt/jboss/domain/data/content"

        grep 'deployment name=' /opt/jboss/domain/configuration/domain.xml -a1 |awk -F '"' '{print $2}' |awk '!($0 in i) {i[$0] ; print}'|sed '/^$/d' > /tmp/dadoscerto

        grep -E -v ".war|.ear" /tmp/dadoscerto > /tmp/t1

        grep -E ".war|.ear" /tmp/dadoscerto > /tmp/t2

        paste /tmp/t1 /tmp/t2 > /tmp/out2

        while read line

        do

          array=($line)

          nome=${array[@]:1}

          dirCompleto=${array[0]}

          dirCom2Letras=$dirCompleto

          echo "cp $JBOSSCONTENT/`echo $dirCom2Letras| awk '{ print substr( $0, 0, 2 ) }'`/`echo $dirCompleto| awk '{ print substr( $0, length($0) - 37, length($0) ) }'`/content /opt/jboss/backup/$nomeDir/$nome-`date +%Y%d%m-%H%M`"

        done < /tmp/out2  > /tmp/dados_puro

 

        sed -n '/^.\{51\}/p' /tmp/dados_puro > /tmp/dados.sh

        chmod +x /tmp/dados.sh

        /tmp/dados.sh
