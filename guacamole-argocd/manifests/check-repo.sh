#!/bin/bash
echo "=== VERIFICAÇÃO DO REPOSITÓRIO ==="

echo "🌐 Testando acesso público ao repo:"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://github.com/Rafael-Clair-Violin/k8s-homelab-manifests)
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Repositório é PÚBLICO"
else
    echo "🔒 Repositório é PRIVADO (HTTP: $HTTP_CODE)"
fi

echo ""
echo "📋 Repositórios já configurados no ArgoCD:"
kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=repository -o name 2>/dev/null || echo "❌ Nenhum repositório configurado"

echo ""
echo "🔑 Secrets relacionados a repositórios:"
kubectl get secret -n argocd | grep -E "(repo|git|token)" || echo "❌ Nenhum secret encontrado"

echo ""
echo "🔄 Forçar refresh da aplicação:"
kubectl patch application guacamole -n argocd --type merge -p='{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'

