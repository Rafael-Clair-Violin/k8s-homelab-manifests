#!/bin/bash
echo "=== DIAGNÓSTICO COMPLETO DE AUTENTICAÇÃO ==="

echo "🔍 1. Verificando secret atual:"
kubectl get secret repo-362575405 -n argocd -o jsonpath='{.data.password}' | base64 -d | wc -c
echo " caracteres no token atual"

echo ""
echo "🔍 2. Verificando dados do repositório:"
echo "URL: $(kubectl get secret repo-362575405 -n argocd -o jsonpath='{.data.url}' | base64 -d)"
echo "Username: $(kubectl get secret repo-362575405 -n argocd -o jsonpath='{.data.username}' | base64 -d)"
echo "Type: $(kubectl get secret repo-362575405 -n argocd -o jsonpath='{.data.type}' | base64 -d)"

echo ""
echo "🔍 3. Logs detalhados do repo-server:"
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-repo-server --tail=20 | grep -A5 -B5 "authentication\|failed\|error" || echo "Nenhum erro específico encontrado"

echo ""
echo "🔍 4. Verificando se o ArgoCD consegue acessar o repo:"
kubectl exec -n argocd deployment/argocd-repo-server -- sh -c "git ls-remote https://github.com/Rafael-Clair-Violin/k8s-homelab-manifests.git" 2>&1 || echo "❌ Falha no acesso direto"

