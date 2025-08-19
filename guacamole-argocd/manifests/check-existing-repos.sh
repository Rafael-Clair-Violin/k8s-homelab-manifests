#!/bin/bash
echo "=== VERIFICAÇÃO DOS REPOSITÓRIOS CONFIGURADOS ==="

for repo in $(kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=repository -o name); do
    echo ""
    echo "🔍 Verificando $repo:"
    kubectl get $repo -n argocd -o jsonpath='{.data.url}' | base64 -d
    echo ""
    echo "   Tipo: $(kubectl get $repo -n argocd -o jsonpath='{.data.type}' | base64 -d 2>/dev/null || echo 'N/A')"
    echo "   Username: $(kubectl get $repo -n argocd -o jsonpath='{.data.username}' | base64 -d 2>/dev/null || echo 'N/A')"
    echo "---"
done

echo ""
echo "🔄 Status atual da aplicação:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.conditions[0].message}'
echo ""

