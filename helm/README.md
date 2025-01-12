# Helm

## Overview de Helm

[documentatin officiel de charte](https://helm.sh/fr/docs/intro/using_helm/)

### Trois grands concepts

##### Package 
Un Chart est un package Helm. Il contient toutes les définitions des ressources nécessaires pour exécuter une application, un outil ou un service à l'intérieur d'un cluster Kubernetes. Voyez cela comme l'équivalent Kubernetes d'une formule pour Homebrew, d'un dpkg pour Apt , ou d'un fichier RPM pour Yum.

##### Depot
Un Dépot est le lieu où les charts peuvent être collectés et partagés. C'est comme les archives CPAN de Perl ou la base de données de packages Fedora, mais pour les packages de Kubernetes.

##### Release
Une Release est une instance d'un chart s'exécutant dans un cluster Kubernetes. Un chart peut être installé plusieurs fois dans le même cluster. Et à chaque fois qu'il est à nouveau installé, une nouvelle release est créé. Prenons un chart MySQL, si vous voulez deux bases de données s'exécutant dans votre cluster, vous pouvez installer ce chart deux fois. Chacune aura sa propre release, qui à son tour aura son propre release name.


Helm installe des charts dans Kubernetes, créant une nouvelle release pour chaque installation. Et pour trouver de nouveaux charts, vous pouvez rechercher des repositories (dépots) de charts Helm.

## Charte

Un Chart Helm est un ensemble de fichiers et de répertoires qui définissent un package d'application Kubernetes. L'architecture générale d'un Chart Helm est organisée de manière à contenir à la fois des définitions de ressources Kubernetes et des mécanismes permettant de personnaliser ces ressources. Voici une vue d'ensemble des éléments clés d'un dossier de Chart

#### Structure générale d'un Chart Helm

```python
<chart-name>/
│
├── charts/             # Dépendances (autres charts Helm : peut etre sous forme de zib; targz)
├── templates/          # Fichiers de modèles Kubernetes (manifests: configMap, service, deployments ..)
├── values.yaml         # Valeurs par défaut de configuration
├── Chart.yaml          # Métadonnées du Chart
├── README.md           # (optionnel) Documentation du Chart
└── values.schema.json  # (optionnel) Schéma de validation des valeurs (si utilisé)
```

#### Détail des composants :

- Chart.yaml :
Ce fichier contient les métadonnées de base du Chart. Il est essentiel pour décrire le Chart et spécifier ses informations comme le nom, la version, la description, les dépendances, etc.

```yaml
apiVersion: v2
name: mychart
description: A Helm chart for Kubernetes
version: 1.0.0
appVersion: "1.14.0"
dependencies:
  - name: mysql
    version: 1.2.3
    repository: "https://charts.example.com"
```

- values.yaml :
Ce fichier contient des valeurs par défaut qui seront utilisées pour remplir les variables dans les templates des ressources Kubernetes. C’est ici que l'on définit les configurations par défaut pour l’application, telles que les réplicas, les images 

```yaml
replicaCount: 2
image:
  repository: my-app
  tag: "1.0"
service:
  type: ClusterIP

```

- templates/ :
Ce répertoire contient les fichiers de modèles Kubernetes (manifests). Ces fichiers sont utilisés pour générer des ressources Kubernetes comme des Deployments, Services, ConfigMaps, etc. Helm utilise un moteur de templating basé sur Go pour remplacer les valeurs dans ces fichiers en fonction des entrées du fichier values.yaml ou des paramètres fournis par l'utilisateur.
Exemple de fichier deployment.yaml dans templates/ :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}
    spec:
      containers:
        - name: {{ .Release.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 8080
```

- charts/ :
Ce répertoire contient des charts Helm qui sont des dépendances pour ce chart. Par exemple, si votre application nécessite une base de données comme MySQL, vous pouvez inclure un chart MySQL comme dépendance dans ce répertoire. Ces charts peuvent être téléchargés depuis un dépôt externe ou être stockés localement.
Exemple :

```graphql
charts/
  └── mysql-1.2.3.tgz
```

- values.schema.json (optionnel) :
Ce fichier est utilisé pour définir un schéma JSON qui valide les valeurs de configuration dans values.yaml. Ce fichier est utilisé dans Helm 3+ pour fournir une validation stricte des valeurs utilisateur (par exemple, type de données, valeurs possibles).
Exemple :

```yaml
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "replicaCount": {
      "type": "integer",
      "minimum": 1
    },
    "image": {
      "type": "object",
      "properties": {
        "repository": { "type": "string" },
        "tag": { "type": "string" }
      }
    }
  }
}
```

#### Processus de fonctionnement :

Déploiement avec Helm : Lorsqu'un Chart est déployé (avec la commande helm install ou helm upgrade), Helm utilise les fichiers de modèle dans le répertoire templates/ et remplace les variables par les valeurs définies dans le fichier values.yaml ou passées par l'utilisateur.

Rendu des fichiers Kubernetes : Helm génère les fichiers Kubernetes à partir des modèles, remplaçant les valeurs dynamiques par les données appropriées. Ces fichiers sont ensuite envoyés à Kubernetes pour créer les ressources définies (comme les Pods, Services, ConfigMaps, etc.).


## Commands de gestion de Chartes

[documentatin officiel de charte](https://helm.sh/fr/docs/intro/cheatsheet/)


#### Installation d'un Chart


- Afficher les options de configuration d'un charte
```bash
helm show values <charte-name>
```


- Afficher l'etat d'un charte 
```bash
helm status <charte-name>
# for commands may used kubect on the cluster
```


- Installer un chart pour la première fois :
```bash
helm install <release-name> <chart-path-or-repo>
#
helm install my-app ./my-chart
```


- Installer avec des valeurs spécifiques :
```bash
helm install <release-name> <chart-path-or-repo> --set key=value
#
helm install my-app ./my-chart --set replicaCount=2
```


- Utiliser un fichier de valeurs :
```bash
helm install <release-name> <chart-path-or-repo> -f values.yaml
```


#### Mise à jour d'un Chart


- Mettre à jour une release existante (upgrade) :

```bash
helm upgrade <release-name> <chart-path-or-repo>
#
helm upgrade my-app ./my-chart

```


- Mettre à jour avec des valeurs spécifiques :
```bash
helm upgrade <release-name> <chart-path-or-repo> --set key=value
#
helm upgrade my-app ./my-chart --set image.tag=2.0
```


- Simuler une mise à jour (dry-run) :
```bash
helm upgrade <release-name> <chart-path-or-repo> --dry-run
```


#### Rollback d'une Release

- helm history <release-name>
```bash
helm history <release-name>
```


- Revenir à une version précédente :
```bash
helm rollback <release-name> <revision>

#
helm rollback my-app 1
```


#### Suppression d'une Release


- Supprimer une release :
```bash
helm uninstall <release-name>
#
helm uninstall my-app

```


- Forcer la suppression en cas de problème :
```bash
helm uninstall <release-name> --force
```


#### Inspecter et Déboguer

- helm get values <release-name>
```bash
helm get values <release-name>
```


- Voir les manifests générés :
```bash
helm get manifest <release-name>
```


- Inspecter les notes associées à une release :
```bash
helm get notes <release-name>
```


- Déboguer un chart avant installation (dry-run) :
```bash
helm install <release-name> <chart-path-or-repo> --dry-run --debug
```


#### Recherche et Exploration


- Rechercher un chart dans un dépôt :
```bash
helm search repo <chart-name>
#
helm search repo mysql
```


- Lister les releases installées :
```bash
helm list
```


- Afficher les informations sur un chart :
```bash
helm show chart <chart-path-or-repo>
```


- Afficher les valeurs par défaut d'un chart :
```bash
helm show values <chart-path-or-repo>
```


#### Gestion des Dépôts de Charts


- Ajouter un dépôt :
```bash
helm repo add <repo-name> <repo-url>
#
helm repo add bitnami https://charts.bitnami.com/bitnami
```


- Mettre à jour les informations du dépôt :
```bash
helm repo update
```


- Lister les dépôts configurés :
```bash
helm repo list
```


- Supprimer un dépôt :
```bash
helm repo remove <repo-name>
```


#### Création et Gestion de Charts


- Créer un nouveau chart :
```bash
helm create <chart-name>
#
helm create my-chart
```


- Valider un chart local :
```bash
helm lint <chart-path>
```


- Emballer un chart pour distribution :
```bash
helm package <chart-path>
```


- Déployer un chart dans un dépôt :
```bash
helm push <chart-file> <repo-name>
```



#### Sauvegarde et Restauration


- Exporter les valeurs d'une release pour sauvegarde :
```bash
helm get values <release-name> -o yaml > backup-values.yaml
```


- Réinstaller une release avec une sauvegarde :
```bash
helm install <release-name> <chart-path-or-repo> -f backup-values.yaml
```


#### Gestion des Hooks (facultatif)

- Voir les événements des hooks :
```bash
helm get hooks <release-name>
```
