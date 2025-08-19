# Comando completo de diagnóstico
echo "=== DIAGNÓSTICO ARGOCD ==="
echo ""
echo "📱 Aplicação:"
kubectl get application guacamole -n argocd -o wide 2>/dev/null || echo "❌ Aplicação não encontrada"

echo ""
echo "🖥️ Pods ArgoCD:"
kubectl get pods -n argocd | grep -E "(server|application-controller|repo-server)"

echo ""
echo "🔗 Repositório configurado:"
git remote get-url origin

echo ""
echo "🌿 Branch atual:"
git branch --show-current

echo ""
echo "📋 Detalhes da aplicação (se existir):"
kubectl describe application guacamole -n argocd 2>/dev/null | tail -20 || echo "❌ Aplicação não encontrada"

