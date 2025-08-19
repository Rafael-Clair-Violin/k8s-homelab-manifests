#!/bin/bash
echo "=== TESTANDO REPOSIT??RIO P??BLICO ==="

echo "???? 1. Testando acesso ao reposit??rio..."
curl -s "https://github.com/Rafael-Clair-Violin/k8s-homelab-manifests" | grep -q "This repository" && echo "??? Reposit??rio acess??vel" || echo "??? Problema de acesso"

echo -e "\n???? 2. For??ando refresh da aplica????o..."
kubectl annotate application guacamole -n argocd argocd.argoproj.io/refresh=hard --overwrite

echo -e "\n??? 3. Aguardando (20s)..."
sleep 20

echo -e "\n???? 4. Status da aplica????o:"
kubectl get applications -n argocd guacamole -o wide

echo -e "\n???? 5. Detalhes:"
HEALTH=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.health.status}' 2>/dev/null)
SYNC=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.sync.status}' 2>/dev/null)
echo "Health: $HEALTH | Sync: $SYNC"

echo -e "\n??????? 6. Verificando namespace:"
kubectl get namespace guacamole 2>/dev/null && echo "??? Namespace criado!" || echo "??? Ainda criando..."

echo -e "\n???? 7. ??ltimos eventos:"
kubectl get events -n argocd --field-selector involvedObject.name=guacamole --sort-by='.lastTimestamp' | tail -3
