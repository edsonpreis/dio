#!/bin/bash

# Definição de usuários e grupos
USUARIOS_ADM=("carlos" "maria" "joao_")
USUARIOS_VEN=("debora" "sebastiana" "roberto")
USUARIOS_SEC=("josefina" "amanda" "rogerio")

GRUPOS=("GRP_ADM" "GRP_VEN" "GRP_SEC")
DIRETORIOS=("/adm" "/ven" "/sec" "/publico")

# Removendo diretórios, grupos e usuários existentes
echo "Removendo diretórios, grupos e usuários existentes..."
for DIR in "${DIRETORIOS[@]}"; do
    rm -rf "$DIR"
done

for GRUPO in "${GRUPOS[@]}"; do
    groupdel "$GRUPO" 2>/dev/null
done

for USUARIO in "${USUARIOS_ADM[@]}" "${USUARIOS_VEN[@]}" "${USUARIOS_SEC[@]}"; do
    userdel -r "$USUARIO" 2>/dev/null
done

# Criando grupos
echo "Criando grupos..."
for GRUPO in "${GRUPOS[@]}"; do
    groupadd "$GRUPO"
done

# Criando diretórios
echo "Criando diretórios..."
for DIR in "${DIRETORIOS[@]}"; do
    mkdir "$DIR"
done

# Ajustando dono dos diretórios para root
chown root:root /adm /ven /sec /publico
chmod 777 /publico

# Criando usuários e adicionando aos grupos
echo "Criando usuários e associando aos grupos..."
for USUARIO in "${USUARIOS_ADM[@]}"; do
    useradd -m -s /bin/bash -G GRP_ADM "$USUARIO"
done

for USUARIO in "${USUARIOS_VEN[@]}"; do
    useradd -m -s /bin/bash -G GRP_VEN "$USUARIO"
done

for USUARIO in "${USUARIOS_SEC[@]}"; do
    useradd -m -s /bin/bash -G GRP_SEC "$USUARIO"
done

# Ajustando permissões dos diretórios
echo "Ajustando permissões..."
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

chmod 770 /adm
chmod 770 /ven
chmod 770 /sec

# Resumo da configuração
echo "Configuração concluída. Resumo:"
ls -ld /adm /ven /sec /publico
echo "Usuários e grupos:"
cat /etc/group | grep GRP_

echo "Provisionamento finalizado com sucesso!"
