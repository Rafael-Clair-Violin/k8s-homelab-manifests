#!/bin/bash
echo "=== VERIFICAÇÃO PÓS-ATUALIZAÇÃO ==="

echo "📊 Status da aplicação:"
kubectl get application guacamole -n argocd -o wide

echo ""
echo "🔍 Condições da aplicação:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.conditions[*].message}' | tr ' ' '\n'

echo ""
echo "🎯 Health status:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.health.status}'

echo ""
echo "🔄 Sync status:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.sync.status}'

echo ""
echo "📋 Se ainda houver problemas, logs do repo-server:"
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server --tail=5 | grep -i error || echo "✅ Nenhum erro encontrado"

