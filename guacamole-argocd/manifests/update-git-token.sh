#!/bin/bash
echo "=== ATUALIZAÇÃO DO TOKEN GITHUB ==="

echo "🔑 Você precisa gerar um novo GitHub Personal Access Token:"
echo "📋 Acesse: https://github.com/settings/tokens"
echo "   1. Clique em 'Generate new token (classic)'"
echo "   2. Marque 'repo' (Full control of private repositories)"
echo "   3. Copie o token gerado"
echo ""

read -p "Cole seu NOVO GitHub Personal Access Token aqui: " NEW_GITHUB_TOKEN

if [ -z "$NEW_GITHUB_TOKEN" ]; then
    echo "❌ Token não fornecido. Abortando..."
    exit 1
fi

echo ""
echo "🔄 Atualizando token no secret existente..."

# Atualizar apenas a senha/token no secret existente
kubectl patch secret repo-362575405 -n argocd --type merge -p="{\"data\":{\"password\":\"$(echo -n "$NEW_GITHUB_TOKEN" | base64 -w 0)\"}}"

echo "✅ Token atualizado com sucesso!"

echo ""
echo "🔄 Forçando refresh da aplicação..."
kubectl patch application guacamole -n argocd --type merge -p='{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'

echo ""
echo "⏱️ Aguardando 20 segundos para sincronização..."
sleep 20

echo ""
echo "📊 Status da aplicação após atualização:"
kubectl get application guacamole -n argocd -o wide

echo ""
echo "🔍 Verificando se o erro foi resolvido:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.conditions[0].message}'
echo ""

echo ""
echo "🎯 Se ainda houver erro, execute:"
echo "kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server --tail=10"

