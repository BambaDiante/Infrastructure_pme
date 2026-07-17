#!/bin/bash
set -e

BASE="/opt/rnd"

echo "=== Création de l'arborescence ==="
mkdir -p "$BASE"/projets/{actifs,archives,templates}
mkdir -p "$BASE"/docs/{techniques,rapports}
mkdir -p "$BASE"/outils/scripts
mkdir -p "$BASE"/logs

echo "=== Application des propriétaires et groupes ==="
chown root:rnd "$BASE"
chown root:rnd "$BASE"/projets
chown root:ingenieurs "$BASE"/projets/actifs
chown diallo:chefs "$BASE"/projets/archives
chown root:rnd "$BASE"/projets/templates
chown root:rnd "$BASE"/docs
chown root:ingenieurs "$BASE"/docs/techniques
chown diallo:chefs "$BASE"/docs/rapports
chown root:rnd "$BASE"/outils
chown root:automatisation "$BASE"/outils/scripts
chown root:rnd "$BASE"/logs

echo "=== Application des permissions ==="
chmod 750 "$BASE"
chmod 750 "$BASE"/projets
chmod 2770 "$BASE"/projets/actifs
chmod 2750 "$BASE"/projets/archives
chmod 2750 "$BASE"/projets/templates
chmod 750 "$BASE"/docs
chmod 750 "$BASE"/docs/techniques
chmod 2770 "$BASE"/docs/rapports
chmod 750 "$BASE"/outils
chmod 2770 "$BASE"/outils/scripts
chmod 1777 "$BASE"/logs

echo "=== Arborescence finale ==="
ls -laR "$BASE"