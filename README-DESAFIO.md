# Desafio — Sock Shop

## 1. Visão geral

Este projeto utiliza a aplicação de microsserviços Sock Shop para demonstrar a implantação de uma aplicação em Kubernetes local, a automação da infraestrutura e a configuração de ferramentas de observabilidade.

O objetivo foi implementar e documentar recursos de infraestrutura, monitoramento, visualização de métricas, coleta de logs e gerenciamento de alertas.

## 2. Tecnologias utilizadas

- Docker Desktop: execução dos containers.
- Kubernetes (Kind): execução local do cluster.
- Terraform: automação da criação da infraestrutura local.
- Prometheus: coleta e consulta de métricas.
- Grafana: visualização de métricas em dashboards.
- Fluent Bit: coleta e encaminhamento de logs.
- Elasticsearch: armazenamento e indexação de logs.
- Kibana: interface de consulta e visualização de logs.
- Jaeger: interface para rastreamento distribuído.
- Alertmanager: recebimento e gerenciamento de alertas do Prometheus.
- Git: controle de versão do projeto.

## 3. Infraestrutura Kubernetes

Foi utilizado o Kind para executar um cluster Kubernetes localmente, permitindo implantar os componentes da aplicação sem depender de um cluster em nuvem.

A configuração de infraestrutura foi organizada em:

`deploy/kubernetes/terraform-local/`

Os manifests Kubernetes da aplicação estão em:

`deploy/kubernetes/manifests/`

A configuração de Ingress e certificado local foi adicionada para permitir o acesso à aplicação por meio do ambiente local.

## 4. Monitoramento com Prometheus e Grafana

O Prometheus foi configurado para coletar métricas do próprio servidor e do serviço front-end da aplicação.

Foram configurados:
- Intervalo de coleta de 30 segundos.
- Consulta de métricas dos alvos configurados.
- Regra de alerta para detectar alvos indisponíveis.
- Grafana como interface de visualização das métricas.
- Dashboard para apresentar os dados coletados.

A configuração encontra-se em:

`deploy/observabilidade/prometheus-grafana/`

## 5. Gerenciamento de alertas com Alertmanager

O Alertmanager foi implantado no namespace `sock-shop` e integrado à configuração do Prometheus.

Foi criada a regra `PrometheusTargetDown`, baseada na expressão `up == 0`.

Validações realizadas:
- Regra carregada e avaliada pelo Prometheus.
- Conexão com o Alertmanager identificada pela API do Prometheus.
- Recebimento e exibição de um alerta de teste enviado diretamente à API do Alertmanager.

*Limitação:* o disparo automático de uma regra do Prometheus e seu encaminhamento até o Alertmanager ainda não foram comprovados. Não foram configurados destinos externos de notificação, como e-mail ou Discord.

## 6. Coleta e visualização de logs

Foram adicionados manifests para Fluent Bit, Elasticsearch e Kibana.

O Fluent Bit foi configurado para coletar logs dos containers e encaminhá-los ao serviço Elasticsearch. O Kibana foi incluído como interface para consulta e visualização.

Os componentes foram implantados e suas configurações foram verificadas durante os testes. Entretanto, a ingestão e a visualização completa dos logs não foram validadas integralmente de ponta a ponta.

Os manifests estão organizados em:

- `deploy/observabilidade/fluent-bit/`
- `deploy/observabilidade/elastic-kibana/`

## 7. Rastreamento distribuído

O Jaeger foi implantado para disponibilizar uma interface de rastreamento distribuído.

A interface pode ser acessada localmente por meio de port-forward, quando o serviço estiver em execução.

*Limitação:* não foi comprovado o recebimento de traces reais do serviço `shipping`. Portanto, a implantação da ferramenta não deve ser interpretada como validação completa do APM da aplicação.

## 8. Como executar o ambiente

Pré-requisitos:
- Docker Desktop em execução.
- kubectl instalado.
- Kind instalado.
- Terraform instalado.

A criação do cluster pode ser gerenciada pela configuração Terraform localizada em `deploy/kubernetes/terraform-local/`.

Após a criação do cluster, os manifests necessários podem ser aplicados com `kubectl apply -f`, respeitando a ordem de implantação e os namespaces definidos nos arquivos.

Para verificar os recursos:

No terminal:

kubectl get nodes
kubectl get pods -n sock-shop
kubectl get services -n sock-shop


Para acessar o Prometheus:

kubectl port-forward -n sock-shop service/prometheus 9090:9090

Acesse `http://localhost:9090`.

Para acessar o Alertmanager:

kubectl port-forward -n sock-shop service/alertmanager 9093:9093

Acesse `http://localhost:9093`.

Para acessar o Grafana:

kubectl port-forward -n sock-shop service/grafana 3000:3000

Acesse `http://localhost:3000`.

Os comandos de port-forward devem permanecer em execução no terminal enquanto as interfaces estiverem sendo utilizadas.

## 9. Evidências

Foram registradas capturas de tela para documentar:
- Interface e métricas do Prometheus.
- Dashboard do Grafana.
- Configuração e conectividade do Alertmanager.
- Recebimento de um alerta de teste no Alertmanager.
- Acesso local à aplicação por Ingress.

As evidências complementam a documentação das configurações implementadas.

## 10. Considerações finais

O projeto demonstra a implantação local de uma aplicação de microsserviços em Kubernetes, automação de infraestrutura e configuração de ferramentas de observabilidade.

Algumas validações de ponta a ponta, especialmente ingestão de logs, rastreamento distribuído e disparo automático de alertas, permaneceram pendentes devido às limitações de recursos do ambiente local e ao escopo de tempo disponível.

O repositório registra as configurações implementadas e as limitações conhecidas de forma transparente.