#!/bin/bash
echo "=== VERIFICANDO LOGS DO ARGOCD ==="

echo "📋 1. Logs do Application Controller:"
kubectl logs -n argocd argocd-application-controller-0 --tail=20 | grep -i guacamole

echo -e "\n📋 2. Logs do Repo Server:"
kubectl logs -n argocd argocd-repo-server-744d6b6bf6-2c8vv --tail=20 | grep -i -E "(error|guacamole|manifests)"

echo -e "\n📋 3. Todos os logs recentes do Repo Server:"
kubectl logs -n argocd argocd-repo-server-744d6b6bf6-2c8vv --tail=10

