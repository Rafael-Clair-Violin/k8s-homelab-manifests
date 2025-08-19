#!/bin/bash
echo "=== DIAGNÓSTICO AVANÇADO ==="

echo "🔍 1. Verificando se o repositório realmente existe..."
curl -I "https://github.com/Rafael-Clair-Violin/k8s-homelab-manifests" 2>/dev/null | head -1

echo -e "\n🌐 2. Testando conectividade DNS..."
nslookup github.com | grep -A 2 "Name:"

echo -e "\n📋 3. Verificando configuração atual da aplicação:"
kubectl get application guacamole -n argocd -o yaml | grep -A 10 "spec:"

echo -e "\n🔧 4. Verificando se há repositório configurado no ArgoCD:"
kubectl get secret -n argocd -l argocd.argoproj.io/secret-type=repository

echo -e "\n📊 5. Status detalhado da aplicação:"
kubectl describe application guacamole -n argocd | tail -20

echo -e "\n🏗️ 6. Logs do ArgoCD Application Controller:"
kubectl logs -n argocd deployment/argocd-application-controller --tail=10 | grep -i guacamole

echo -e "\n🔄 7. Logs do ArgoCD Repo Server:"
kubectl logs -n argocd deployment/argocd-repo-server --tail=10 | grep -i error

