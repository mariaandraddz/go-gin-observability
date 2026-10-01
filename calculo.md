1. Métricas de Tempo / Latência (Quanto está demorando)
A. Tempo Médio de Execução (em milissegundos)
Calcula a média de tempo que as requisições estão levando para responder por rota e método:

(rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])) * 1000

B. Percentil 95 - Latência p95 (Recomendado)
Mede o tempo máximo de resposta que 95% dos seus usuários estão experimentando (ignorando apenas o 5% dos casos mais lentos/outliers):

histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, path)) * 1000


C. Percentil 99 - Latência p99 (Casos mais lentos)
Mede o tempo limite de resposta para os 1% das requisições mais demoradas:
histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, path)) * 1000

2. Métricas de Volume / Taxa de Requisições
   A. Requisições por Segundo (RPS) por Rota e Status
   Mostra o volume de acessos divididos pelos códigos de resposta HTTP (200, 404, etc.):
sum(rate(http_request_total[1m])) by (path, status, method)

B. Porcentagem / Taxa de Erros HTTP
Mostra quantas requisições falharam (status 4xx ou 5xx) em relação ao total:
sum(rate(http_request_total{status=~"[45].."}[5m])) / sum(rate(http_request_total[5m])) * 100