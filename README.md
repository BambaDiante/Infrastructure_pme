# Projet Infrastructure Sécurisée - Département R&D Innovation

**Auteurs :**
Ahmadou Bamba Diante
Khadidiatou Ly

**Date :** 18/07/2026

## Description

Ce projet met en place l'infrastructure Linux du département R&D Innovation
de GlobalCorp : création des utilisateurs/groupes, arborescence sécurisée,
permissions standards et spéciales, ACL, et délégation sudo.

## Prérequis

- Distribution Linux Debian/Ubuntu (testé sur Ubuntu 22.04)
- Accès root ou sudo
- Paquet `acl` installé pour la gestion des ACL :

```bash
sudo apt install acl
```

## Structure du dépôt
```
AhmadouBambaDiante&KhadidiatouLY_PROJET_RND/
├── rapport.pdf              # Rapport détaillé avec captures d'écran
├── README.md                # Ce fichier
├── scripts/
│   ├── create_users.sh      # Création des groupes et utilisateurs
│   ├── setup_structure.sh   # Arborescence /opt/rnd/ + permissions + bits spéciaux + ACL
│   └── audit_rnd.sh         # Script d'audit (permissions, ACL, utilisateurs, sudo)
└── configs/
├── sudoers_rnd          # Règles de délégation sudo (à copier dans /etc/sudoers.d/)
└── acl_backup.txt       # Sauvegarde des ACL générée par getfacl -R
```
## Ordre d'exécution

Exécutez les scripts dans cet ordre précis, en tant que root :

```bash
chmod +x scripts/*.sh

# 1. Créer les utilisateurs et groupes
sudo ./scripts/create_users.sh

# 2. Créer l'arborescence et appliquer les permissions
sudo ./scripts/setup_structure.sh
# → crée l'arborescence /opt/rnd/, applique les permissions standards,
#   les bits spéciaux (SGID/sticky bit) et les ACL

# 3. Copier et activer les règles sudo
sudo cp configs/sudoers_rnd /etc/sudoers.d/rnd-delegation
sudo chmod 440 /etc/sudoers.d/rnd-delegation
sudo chown root:root /etc/sudoers.d/rnd-delegation
sudo visudo -c -f /etc/sudoers.d/rnd-delegation

# 4. Lancer l'audit pour vérifier l'ensemble de la configuration
sudo ./scripts/audit_rnd.sh
```

## Mots de passe temporaires

Tous les utilisateurs créés ont un mot de passe temporaire (voir `create_users.sh`).
Ces mots de passe doivent être changés par les utilisateurs à leur première connexion.

## Vérifications rapides

```bash
# Vérifier qu'un utilisateur existe avec les bons groupes
id fatou

# Vérifier les ACL d'un répertoire
getfacl /opt/rnd/docs/techniques

# Vérifier les droits sudo d'un ingénieur
su - fatou -c "sudo -l"

# Vérifier qu'un stagiaire n'a aucun droit sudo
su - ali -c "sudo -l"

# Vérifier les droits sudo d'un utilisateur (vue admin)
sudo -l -U mamadou
```

## Sauvegarde des ACL

La sauvegarde des ACL de `/opt/rnd/` a été générée avec la commande suivante,
et se trouve dans `configs/acl_backup.txt` :

```bash
getfacl -R /opt/rnd > configs/acl_backup.txt
```


## Documentation complémentaire

Le guide d'administration destiné au successeur (procédure d'ajout d'un
ingénieur, sauvegarde/restauration des ACL, commandes utiles au quotidien)
se trouve en annexe du `rapport.pdf`.