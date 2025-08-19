#!/bin/bash
echo "=== VERIFICAÇÃO COMPLETA DO DEPLOYMENT ==="

echo "📊 1. Status da Aplicação ArgoCD:"
kubectl get applications -n argocd guacamole -o wide 2>/dev/null || echo "❌ Aplicação não encontrada"

echo -e "\n📊 2. Health e Sync Status:"
HEALTH=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.health.status}' 2>/dev/null)
SYNC=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.sync.status}' 2>/dev/null)
echo "Health: $HEALTH | Sync: $SYNC"

echo -e "\n📊 3. Recursos no namespace guacamole:"
kubectl get all -n guacamole 2>/dev/null || echo "⏳ Namespace ainda sendo criado..."

echo -e "\n📊 4. Namespace guacamole:"
kubectl get namespace guacamole 2>/dev/null || echo "⏳ Namespace não existe ainda"

echo -e "\n📊 5. Últimos eventos da aplicação:"
kubectl describe application guacamole -n argocd 2>/dev/null | tail -10 || echo "❌ Aplicação não encontrada"

echo -e "\n📊 6. Logs do ArgoCD Application Controller:"
kubectl logs -n argocd argocd-application-controller-0 --tail=5 | grep -i guacamole || echo "✅ Nenhum erro recente"

