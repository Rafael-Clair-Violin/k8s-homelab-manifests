#!/bin/bash
echo "=== CORRIGINDO TARGET REVISION ==="

echo "🔧 1. Atualizando aplicação para usar branch main..."
kubectl patch application guacamole -n argocd --type='merge' -p='{"spec":{"source":{"targetRevision":"main"}}}'

echo -e "\n⏳ 2. Aguardando (15s)..."
sleep 15

echo -e "\n🔄 3. Forçando refresh..."
kubectl annotate application guacamole -n argocd argocd.argoproj.io/refresh=hard --overwrite

echo -e "\n⏳ 4. Aguardando sincronização (30s)..."
sleep 30

echo -e "\n📊 5. Verificando status:"
kubectl get application guacamole -n argocd -o wide

