#!/bin/bash
set -e  # arrête le script à la première erreur

echo "=== Création des groupes ==="
groupadd rnd
groupadd chefs
groupadd ingenieurs
groupadd stagiaires
groupadd automatisation

echo "=== Création des utilisateurs ==="

# Chef de projet
useradd -m -s /bin/bash -g chefs -G rnd diallo
echo "diallo:Chef2026!" | chpasswd

# Ingénieurs
for user in fatou mamadou aissatou; do
    useradd -m -s /bin/bash -g ingenieurs -G rnd "$user"
    echo "${user}:Ingenieur2026!" | chpasswd
done

# Stagiaires
for user in ali binta; do
    useradd -m -s /bin/bash -g stagiaires -G rnd "$user"
    echo "${user}:Stagiaire2026!" | chpasswd
done

# Utilisateur technique (pas de shell interactif)
useradd -m -s /bin/false -g automatisation -G rnd ci_runner
echo "ci_runner:Runner2026!" | chpasswd


echo "=== Vérification ==="
for user in diallo fatou mamadou aissatou ali binta ci_runner; do
    echo "--- $user ---"
    id "$user"
    groups "$user"
    echo ""
done