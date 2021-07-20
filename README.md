<i><b>Scritps simples básico e funcional</i></b> 


<i><b>Executado no jboss-eap-7.2.2 e Redhat 7</i></b> 

<b>Script BKP.sh</b>

Executa backup dos pacotes ear deployados na console do jboss domain mode.

--Criar diretorio backup no home do jboss

--Alterar os caminhos do home do jboss

<b>Script startJVM_jboss.sh</b>

--Realiza start da jvm do jboss modo domain, alterar os nomes do server group e user/pass


<b>Script stopJVM_jboss.sh</b>

--Realiza stop da jvm do jboss modo domain, alterar os nomes do server group e user/pass


<b>Script unDeploy_jboss.sh</b>

--Realiza unDeploy dos EAR jboss modo domain, ajustar JBOSS_HOME,DEPLOY_ORIGEM e PATHPACOTE




<b>Script deploy_jboss.sh</b>

--Realiza Deploy dos EARs jboss modo domain, ajustar JBOSS_HOME,DEPLOY_ORIGEM e PATHPACOTE

<b>Script Flush_datasource.sh</b>
--Realiza um flush  datasource connection pool.

--Com base no erro "Unable to fill pool: java:jboss/datasources/" no arquivo server.log, o script faz o flush jboss mode domain.


