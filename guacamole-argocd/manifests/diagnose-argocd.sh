#!/bin/bash
echo "=== DIAGNÓSTICO COMPLETO ARGOCD ==="

echo "🔍 1. Namespace ArgoCD:"
kubectl get namespace argocd 2>/dev/null && echo "✅ Existe" || echo "❌ Não existe"

echo -e "\n🔍 2. Pods ArgoCD:"
kubectl get pods -n argocd 2>/dev/null || echo "❌ Nenhum pod encontrado"

echo -e "\n🔍 3. Services ArgoCD:"
kubectl get svc -n argocd 2>/dev/null || echo "❌ Nenhum service encontrado"

echo -e "\n🔍 4. Deployments ArgoCD:"
kubectl get deployments -n argocd 2>/dev/null || echo "❌ Nenhum deployment encontrado"

echo -e "\n🔍 5. Status dos pods (se existirem):"
kubectl get pods -n argocd -o wide 2>/dev/null | grep -v Running | head -5

echo -e "\n🔍 6. Eventos recentes no namespace argocd:"
kubectl get events -n argocd --sort-by='.lastTimestamp' 2>/dev/null | tail -3 || echo "❌ Nenhum evento"

echo -e "\n🔍 7. Verificar se ArgoCD CRDs existem:"
kubectl get crd | grep argoproj 2>/dev/null || echo "❌ CRDs do ArgoCD não encontrados"


