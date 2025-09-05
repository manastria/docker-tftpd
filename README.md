# Serveur TFTP avec Docker

Ce projet met en place un serveur **TFTP** (Trivial File Transfer Protocol) simple et sécurisé à l'aide de Docker et Docker Compose. Il est idéal pour les environnements de laboratoire, notamment pour sauvegarder et restaurer les configurations d'équipements réseau comme des routeurs Cisco.

##  Installation

Suivez ces étapes pour cloner le projet et le configurer correctement.

### 1. Cloner le dépôt

Ouvrez un terminal et utilisez la commande `git` pour cloner ce dépôt sur votre machine locale.

```bash
git clone https://github.com/manastria/docker-tftpd.git
cd docker-tftpd
```

### 2. Créer le répertoire des données

Le serveur TFTP a besoin d'un répertoire pour stocker les fichiers qu'il sert. Nous allons créer un dossier `tftp-data` à la racine du projet. C'est ce dossier qui sera "monté" dans le conteneur Docker.

```bash
mkdir tftp-data
```

### 3. Gérer les permissions (Étape cruciale)

C'est l'étape la plus importante pour assurer que le serveur puisse **écrire** des fichiers (par exemple, quand un routeur envoie sa configuration).

**Pourquoi ?**
À l'intérieur du conteneur, le service TFTP ne tourne pas en tant que `root` (pour des raisons de sécurité), mais avec un utilisateur système appelé `tftp`. Cet utilisateur a un identifiant numérique (UID) et un identifiant de groupe (GID) spécifiques. Sur l'image Debian utilisée, ces identifiants sont :

  * **UID** = `101` (utilisateur `tftp`)
  * **GID** = `101` (groupe `tftp`)

Nous devons donc nous assurer que le dossier `tftp-data` sur notre machine hôte appartienne à cet utilisateur `101` et à ce groupe `101`.

**Comment ?**
Exécutez la commande suivante pour changer le propriétaire du dossier. L'utilisation de `sudo` est nécessaire car vous modifiez les permissions d'un dossier.

```bash
# Change le propriétaire du dossier pour l'UID 107 et le GID 109
sudo chown 101:101 tftp-data

# (Optionnel mais recommandé) Assure que le groupe a bien les droits d'écriture
sudo chmod 775 tftp-data
```

Votre environnement est maintenant prêt \!

-----

## Utilisation

Les commandes suivantes doivent être lancées depuis la racine du projet (`docker-tftpd`).

  * **Démarrer le serveur :**
    La commande `--build` n'est nécessaire que la première fois ou si vous modifiez le `Dockerfile`.

    ```bash
    docker-compose up -d --build
    ```

  * **Vérifier le statut du conteneur :**

    ```bash
    docker-compose ps
    ```

  * **Consulter les logs en temps réel :**
    C'est très utile pour voir les tentatives de connexion et les transferts de fichiers.

    ```bash
    docker-compose logs -f
    ```

  * **Arrêter le serveur :**

    ```bash
    docker-compose down
    ```

-----

## Fichiers du projet

  * `Dockerfile` : Le plan de construction de l'image Docker. Il installe le serveur `tftpd-hpa` sur une base Debian minimale.
  * `docker-compose.yml` : Le fichier d'orchestration qui définit comment lancer le service, configure le réseau (`network_mode: "host"`) et le volume de données.
  * `tftp-data/` : Le répertoire (que vous avez créé) où les fichiers de configuration de vos équipements seront stockés. Vous pouvez y placer des fichiers que vous souhaitez envoyer à vos équipements.