#!/bin/bash
echo "=== DIAGNÓSTICO DETALHADO ARGOCD ==="

echo "🔍 Logs do Application Controller (últimas 30 linhas):"
kubectl logs -n argocd argocd-application-controller-0 --tail=30 | grep -i -A3 -B3 guacamole

echo ""
echo "🔍 Logs do Repo Server (erros):"
kubectl logs -n argocd argocd-repo-server-8c677cff7-2wq97 --tail=50 | grep -i error

echo ""
echo "🔄 Status YAML da aplicação:"
kubectl get application guacamole -n argocd -o yaml | grep -A 10 -B 5 "conditions\|sync\|health"

echo ""
echo "📁 Estrutura do repositório:"
ls -la

echo ""
echo "📄 Arquivos YAML/YML:"
find . -name "*.yaml" -o -name "*.yml" | head -10


