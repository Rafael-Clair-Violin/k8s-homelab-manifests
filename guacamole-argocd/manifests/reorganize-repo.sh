#!/bin/bash
echo "???? Reorganizando reposit??rio..."

# Criar pasta manifests
mkdir -p manifests

# Mover arquivos YAML da raiz (exceto application.yaml que fica na raiz)
for file in configmaps.yaml guacamole-current.yaml kustomization.yaml secrets.yaml namespace.yaml; do
    if [ -f "$file" ]; then
        mv "$file" manifests/
        echo "??? Movido: $file -> manifests/"
    fi
done

# Mover diret??rios de componentes
for dir in guacamole guacd postgresql; do
    if [ -d "$dir" ]; then
        mv "$dir" manifests/
        echo "??? Movido: $dir/ -> manifests/"
    fi
done

echo -e "\n???? Nova estrutura:"
find manifests -name "*.yaml" | sort

echo -e "\n???? Arquivos na raiz:"
ls -la *.yaml 2>/dev/null || echo "Nenhum arquivo YAML na raiz"
