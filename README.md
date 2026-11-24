# Scripts para JBoss EAP em modo domain

Scripts de administração para ambientes Linux com JBoss EAP. O projeto original foi usado com JBoss EAP 7.2.2 e Red Hat Enterprise Linux 7.

| Script | Finalidade |
| --- | --- |
| [`bkp.sh`](bkp.sh) | Copia os arquivos EAR e WAR gerenciados no domínio. |
| [`deploy_jboss.sh`](deploy_jboss.sh) | Publica pacotes no JBoss. |
| [`unDeploy_jboss.sh`](unDeploy_jboss.sh) | Remove deployments do JBoss. |
| [`startJVM_jboss.sh`](startJVM_jboss.sh) | Inicia JVMs de um grupo de servidores. |
| [`stopJVM_jboss.sh`](stopJVM_jboss.sh) | Para JVMs de um grupo de servidores. |
| [`flush_datasource.sh`](flush_datasource.sh) | Limpa o pool de conexões do datasource a partir de erros detectados no log. |

## Backup de aplicações

Execute com Bash e Python 3.6 ou superior. A conta de execução precisa ler a configuração e o repositório de conteúdo do controlador de domínio e gravar no destino.

```bash
./bkp.sh --help
./bkp.sh --jboss-home /opt/jboss --backup-dir /var/backups/jboss
```

- A instalação padrão é `/opt/jboss`. Use `JBOSS_HOME` ou `--jboss-home` para mudar o caminho.
- A configuração padrão é `domain/configuration/domain.xml` dentro da instalação. Use `--domain-config` para indicar outro arquivo.
- O repositório padrão é `domain/data/content` dentro da instalação. Use `--content-dir` para indicar outro diretório.
- O destino padrão é `backup` dentro da instalação. Use `BACKUP_DIR` ou `--backup-dir` para mudar o destino. Os argumentos de linha de comando têm precedência sobre as variáveis.

Cada execução bem-sucedida gera um diretório `backup-<data UTC>-<identificador>`, com os nomes originais dos deployments. O script identifica os pacotes pelo catálogo global do domínio, independentemente dos grupos que os referenciam, e valida cada cópia pelo SHA-1 registrado no XML. Deployments não gerenciados são ignorados. Conteúdo gerenciado expandido em diretório, pacote ausente ou hash divergente faz a execução falhar antes da publicação do lote.

Para restaurar uma aplicação, publique o EAR ou WAR correspondente no grupo de servidores desejado pelo procedimento de deploy do ambiente. O backup cobre os arquivos dos pacotes. Guarde a configuração do domínio e os dados da aplicação separadamente. Defina a retenção dos diretórios de backup conforme a política do ambiente.

## Outros scripts

Revise os caminhos, os grupos de servidores e os parâmetros da CLI do JBoss antes de executar os scripts legados. Valide operações de deploy, undeploy, inicialização, parada e limpeza de pools em um ambiente de homologação.

## Licença

[GPL-3.0](LICENSE)
