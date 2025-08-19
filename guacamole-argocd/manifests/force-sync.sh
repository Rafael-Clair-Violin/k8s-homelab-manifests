#!/bin/bash
echo "=== FORÇANDO SINCRONIZAÇÃO DA APLICAÇÃO ==="

echo "🔄 1. Adicionando annotation de refresh:"
kubectl annotate application guacamole -n argocd argocd.argoproj.io/refresh=hard --overwrite

echo "⏳ 2. Aguardando processamento (15s)..."
sleep 15

echo "📊 3. Verificando status após refresh:"
kubectl get applications -n argocd guacamole -o wide

echo -e "\n🔍 4. Status detalhado:"
HEALTH=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.health.status}' 2>/dev/null)
SYNC=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.sync.status}' 2>/dev/null)
REVISION=$(kubectl get applications -n argocd guacamole -o jsonpath='{.status.sync.revision}' 2>/dev/null)
echo "Health: $HEALTH | Sync: $SYNC | Revision: $REVISION"

echo -e "\n🏗️ 5. Verificando namespace guacamole:"
kubectl get namespace guacamole 2>/dev/null && echo "✅ Namespace criado!" || echo "⏳ Namespace ainda não existe"

echo -e "\n📦 6. Recursos no namespace (se existir):"
kubectl get all -n guacamole 2>/dev/null || echo "⏳ Recursos ainda sendo criados..."

echo -e "\n📋 7. Últimos logs do controller:"
kubectl logs -n argocd argocd-application-controller-0 --tail=3 | grep -i guacamole || echo "Nenhum log recente"

