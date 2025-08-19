#!/bin/bash
echo "=== RECRIAÇÃO DO SECRET DO REPOSITÓRIO ==="

echo "🗑️ Removendo secret antigo (se existir)..."
kubectl delete secret repo-362575405 -n argocd 2>/dev/null || echo "Secret antigo não encontrado (OK)"

echo ""
echo "🔑 Cole seu GitHub Personal Access Token e pressione ENTER:"
read -s GITHUB_TOKEN

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ Token não fornecido. Abortando..."
    exit 1
fi

echo ""
echo "🚀 Criando novo secret..."

kubectl create secret generic repo-rafael-homelab-new \
  --from-literal=type=git \
  --from-literal=url=https://github.com/Rafael-Clair-Violin/k8s-homelab-manifests \
  --from-literal=password="$GITHUB_TOKEN" \
  --from-literal=username=Rafael-Clair-Violin \
  -n argocd

kubectl label secret repo-rafael-homelab-new -n argocd argocd.argoproj.io/secret-type=repository

echo "✅ Novo secret criado!"

echo ""
echo "🔄 Reiniciando repo-server para aplicar mudanças..."
kubectl rollout restart deployment/argocd-repo-server -n argocd

echo "⏱️ Aguardando reinicialização..."
kubectl rollout status deployment/argocd-repo-server -n argocd

echo ""
echo "🔄 Forçando refresh da aplicação..."
kubectl patch application guacamole -n argocd --type merge -p='{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'

echo "⏱️ Aguardando 30 segundos para sincronização..."
sleep 30

echo ""
echo "📊 Status final:"
kubectl get application guacamole -n argocd -o wide

echo ""
echo "🔍 Verificando condições:"
kubectl get application guacamole -n argocd -o jsonpath='{.status.conditions[0].message}'
echo ""

