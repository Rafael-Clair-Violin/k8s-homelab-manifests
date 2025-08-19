#!/bin/bash
echo "=== VERIFICAÇÃO DO SECRET ATUAL ==="

echo "🔍 Detalhes do secret repo-362575405:"
kubectl get secret repo-362575405 -n argocd -o yaml

echo ""
echo "🔑 Verificando se há senha/token configurado:"
kubectl get secret repo-362575405 -n argocd -o jsonpath='{.data.password}' | base64 -d | wc -c
echo " caracteres na senha atual"

