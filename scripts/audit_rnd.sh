#!/bin/bash

BASE="/opt/rnd"
DATE=$(date +%Y%m%d_%H%M%S)
RAPPORT="/tmp/audit_rnd_${DATE}.txt"

echo "=== AUDIT INFRASTRUCTURE R&D — $(date) ===" | tee "$RAPPORT"

echo -e "\n--- 1. Utilisateurs et groupes ---" | tee -a "$RAPPORT"
for user in diallo fatou mamadou aissatou ali binta ci_runner; do
    if id "$user" &>/dev/null; then
        echo "[OK] $user : $(id "$user")" | tee -a "$RAPPORT"
    else
        echo "[MANQUANT] $user n'existe pas" | tee -a "$RAPPORT"
    fi
done

echo -e "\n--- 2. Permissions de l'arborescence ---" | tee -a "$RAPPORT"
find "$BASE" -maxdepth 3 -exec ls -ld {} \; | tee -a "$RAPPORT"

echo -e "\n--- 3. Vérification des bits spéciaux ---" | tee -a "$RAPPORT"
if [ -d "$BASE/projets/actifs" ]; then
    perm=$(stat -c "%A" "$BASE/projets/actifs")
    if [[ "$perm" == *"s"* ]]; then
        echo "[OK] SGID actif sur $BASE/projets/actifs ($perm)" | tee -a "$RAPPORT"
    else
        echo "[ERREUR] SGID absent sur $BASE/projets/actifs ($perm)" | tee -a "$RAPPORT"
    fi
fi

if [ -d "$BASE/logs" ]; then
    perm=$(stat -c "%A" "$BASE/logs")
    if [[ "$perm" == *"t"* ]]; then
        echo "[OK] Sticky bit actif sur $BASE/logs ($perm)" | tee -a "$RAPPORT"
    else
        echo "[ERREUR] Sticky bit absent sur $BASE/logs ($perm)" | tee -a "$RAPPORT"
    fi
fi

echo -e "\n--- 4. Audit des ACL ---" | tee -a "$RAPPORT"
getfacl -R "$BASE" >> "$RAPPORT" 2>&1
echo "ACL complètes enregistrées dans $RAPPORT"

echo -e "\n--- 5. Vérification des règles sudo ---" | tee -a "$RAPPORT"
if [ -f /etc/sudoers.d/rnd-delegation ]; then
    if visudo -c -f /etc/sudoers.d/rnd-delegation &>/dev/null; then
        echo "[OK] /etc/sudoers.d/rnd-delegation présent et syntaxe valide" | tee -a "$RAPPORT"
    else
        echo "[ERREUR] Erreur de syntaxe dans /etc/sudoers.d/rnd-delegation" | tee -a "$RAPPORT"
    fi
else
    echo "[MANQUANT] /etc/sudoers.d/rnd-delegation introuvable" | tee -a "$RAPPORT"
fi

echo -e "\n--- 6. Espace disque du département ---" | tee -a "$RAPPORT"
du -sh "$BASE" | tee -a "$RAPPORT"

echo -e "\n=== FIN DE L'AUDIT — rapport complet : $RAPPORT ===" | tee -a "$RAPPORT"