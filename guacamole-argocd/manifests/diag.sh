echo "=== DIAGNÓSTICO COMPLETO ==="
echo "1. Status da aplicação:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.sync.status}' && echo ""
kubectl get application guacamole -n argocd -o jsonpath='{.status.health.status}' && echo ""

echo "2. Condições:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.conditions}' | jq '.' 2>/dev/null || echo "Sem condições"

echo "3. Recursos detectados:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.resources}' | jq '.' 2>/dev/null || echo "Nenhum recurso detectado!"

echo "4. Teste do kustomization:"
kubectl kustomize . --dry-run=client | grep -E "kind:|name:|namespace:" | head -10

