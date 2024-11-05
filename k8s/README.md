# Kubernetes


## Introduction

Kubernetes (K8s) est une plateforme open-source permettant l'automatisation du déploiement, de la mise à l'échelle et de la gestion des applications conteneurisées. Kubernetes est idéal pour des systèmes distribués où plusieurs services et applications conteneurisées doivent interagir, souvent dans des environnements de production à grande échelle. Il apporte une gestion dynamique des ressources et une haute disponibilité en optimisant les ressources et en assurant un équilibre de charge.
Quand Kubernetes est-il le bon choix par rapport à Docker-Compose ?

- Scalabilité : Kubernetes permet de mettre facilement à l'échelle des applications conteneurisées, ce qui devient plus difficile à gérer avec Docker-Compose en raison de ses limitations en matière d'orchestration.
- Résilience et Haute Disponibilité : Kubernetes détecte les échecs et redémarre automatiquement les conteneurs défectueux, offrant une fiabilité accrue.
- Gestion des ressources : Kubernetes est conçu pour gérer des clusters de serveurs, contrairement à Docker-Compose, qui est idéal pour orchestrer des applications locales ou de petite échelle.
- Mise à jour continue (rolling updates) : Kubernetes permet des mises à jour sans interruption de service, en remplaçant les conteneurs de manière progressive et contrôlée.
- Orchestration avancée : Kubernetes offre des fonctionnalités telles que la découverte de services, la gestion des volumes et le scaling horizontal de manière native.

## Architecture simplifiée de Kubernetes

![alt text](image.png)

Kubernetes utilise une architecture client-serveur, où les composants principaux sont le cluster et les nodes (nœuds). Voici les éléments fonctionnels clés :

#### Master Node (ou Control Plane):
- API Server : Interface principale permettant aux utilisateurs et aux outils d’interagir avec Kubernetes (interpreteur des commandes clientes).
- Scheduler : Planifie les pods sur les différents nodes en fonction des ressources.
- Controller Manager : Assure l’exécution des contrôleurs (par exemple, contrôleur de réplication).
- Etcd : Base de données clé-valeur où Kubernetes stocke toutes les données du cluster(pods, nemespaces, services, conteneurs ... crées).

#### Worker Nodes :
- Kubelet : Gère les pods sur chaque nœud.
- Kube-proxy : Gère le réseau du cluster en assurant la redirection du trafic vers les bons pods.
- Container Runtime : Environnement d'exécution (comme Docker ou containerd) où les conteneurs s'exécutent.

#### Les composants fonctionnels incluent :

- Pods : Unité de base de déploiement qui contient un ou plusieurs conteneurs.
- Namespaces : Permettent d'isoler les ressources au sein du cluster.
- Nodes : Machines (physiques ou virtuelles) où s’exécutent les pods.
- Services : Créent des points d’accès réseau pour les applications.
- Deployments : Définissent la gestion du cycle de vie des pods, notamment pour la mise à l'échelle et les mises à jour.


## Installation

### Installation via kubeadm (celle de producion)



#### Pré-requis

- Système d'exploitation : Linux (Ubuntu ou CentOS) ou Windows Server.
- Accès root/sudo sur chaque machine.
- Outils nécessaires : kubectl, kubeadm, kubelet, et un runtime conteneur (Docker ou containerd).

- Étapes d'installation

- Installer Docker (ou un autre container runtime) sur chaque machine du cluster.

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```
- Installer les composants Kubernetes (kubectl, kubeadm, kubelet)

```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

- Initialiser le cluster (sur le master node uniquement)

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```
- Configurer kubectl

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- Installer un plugin réseau (par exemple Flannel)

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
Ajouter des nœuds de travail (sur chaque worker node) Rejoindre le cluster à l’aide de la commande join fournie lors de l’initialisation.


- Remarque : Arrêter et redémarrer les services Kubernetes

Vous pouvez arrêter temporairement le cluster en arrêtant les services kubelet et containerd (ou docker, selon votre runtime de conteneurs) sur le nœud maître.


- Pour arrêter le cluster :

```bash
sudo systemctl stop kubelet
sudo systemctl stop containerd   # ou sudo systemctl stop docker
```

- Pour redémarrer le cluster :

```bash
sudo systemctl start kubelet
sudo systemctl start containerd   # ou sudo systemctl start docker
```

Ces commandes arrêteront et redémarreront l’instance Kubernetes en cours d’exécution. Notez que les pods et autres ressources ne seront plus disponibles tant que kubelet et le runtime de conteneurs ne seront pas relancés.

### Installation via minikube (pour du dev)


- Installation de Kubectl :

```bash
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

- Installer Minikube :

```bash
# Sur Linux (exemple avec Ubuntu)
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
```

Démarrer le Cluster avec Minikube :

Lancer Minikube :
```bash
minikube start --driver=docker
```

- Remarque : --driver=docker utilise Docker comme pilote pour exécuter Minikube dans un conteneur. Vous pouvez également utiliser virtualbox, vmware, etc., si Docker n'est pas disponible.

- Vérifier l’état du cluster :

```bash
minikube status
```

3. Commandes d’Administration de Base

- Afficher les informations du cluster :

```bash
kubectl cluster-info
```

- Vérifier les configurations de Minikube :

```bash
minikube config view
```

- Arrêter Minikube (arrête tous les services Kubernetes) :

```bash
minikube stop
```

- Redémarrer Minikube :

```bash
minikube start
```

- Supprimer complètement le cluster Minikube (utile si vous souhaitez réinitialiser l’environnement) :

```bash
minikube delete
```

- Ouvrir le tableau de bord Kubernetes dans le navigateur :

```bash
minikube dashboard
```

- Obtenir l’IP du cluster Minikube (utile pour accéder aux services) :

```bash
minikube ip
```

- Remarques Importantes :

Espace Disque et RAM : Assurez-vous que votre machine dispose de suffisamment de ressources pour exécuter Minikube.
Isolation : Minikube est recommandé pour les environnements de développement local ; il n’est pas destiné aux environnements de production.
Accès aux Pods et Services : Par défaut, Minikube crée des clusters Kubernetes à nœud unique. Tous les services sont accessibles via l’IP Minikube ou le port NodePort.

En utilisant Minikube, vous disposez d’un cluster Kubernetes fonctionnel en local, facile à gérer et prêt pour expérimenter des déploiements, configurations et développements Kubernetes sans complexité de configuration initiale.

### Notions

- Pods : Les unités de déploiement qui contiennent les conteneurs.
- Namespaces : Facilitent la gestion des ressources et permettent l'isolation au sein du cluster.
- Deployments : Gèrent les mises à jour des pods et permettent de définir le nombre de répliques.
- Services : Offrent un point d'accès réseau stable aux pods.
- ConfigMaps et Secrets : Permettent de gérer les configurations et les informations sensibles.
- Volumes : Fournissent un espace de stockage persistant pour les conteneurs.

### Commandes d'administration de base


- Commande sur les nodes

```bash
# Afficher tous les nœuds du cluster
kubectl get nodes

# Afficher les informations détaillées d’un nœud spécifique
kubectl describe node <node-name>

# Marquer un nœud comme indisponible (Drain)
kubectl drain <node-name> --ignore-daemonsets

# Ramener un nœud dans le cluster après un drain
kubectl uncordon <node-name>

# Marquer un nœud comme indisponible sans le drainer (Cordon)
kubectl cordon <node-name>

# Supprimer un nœud du cluster
kubectl delete node <node-name>
```

- Commande sur les namespaces

```bash
# Afficher tous les namespaces
kubectl get namespaces

# Créer un nouveau namespace
kubectl create namespace <namespace-name>

# Supprimer un namespace
kubectl delete namespace <namespace-name>

# Afficher tous les pods dans un namespace spécifique
kubectl get pods -n <namespace-name>

# Changer de namespace pour une commande unique
kubectl --namespace=<namespace-name> <command>

# Configurer le namespace par défaut pour kubectl
kubectl config set-context --current --namespace=<namespace-name>
```

- Commande sur les pods

```bash
# Afficher tous les pods dans le namespace actuel
kubectl get pods

# Afficher tous les pods dans tous les namespaces
kubectl get pods --all-namespaces

# Décrire un pod spécifique
kubectl describe pod <pod-name>

# Supprimer un pod
kubectl delete pod <pod-name>

# Créer un pod à partir d’un fichier YAML
kubectl apply -f <file.yaml>

# Récupérer les logs d’un pod
kubectl logs <pod-name>

# Récupérer les logs d’un conteneur spécifique dans un pod
kubectl logs <pod-name> -c <container-name>

# Lancer une commande dans un pod en cours d'exécution
kubectl exec -it <pod-name> -- <command>

# Mettre à jour un pod sans interruption (Rolling Update)
kubectl rollout restart deployment <deployment-name>
```

- Commande sur les service

```bash
# Afficher tous les services dans le namespace actuel
kubectl get services

# Afficher tous les services dans tous les namespaces
kubectl get services --all-namespaces

# Décrire un service spécifique
kubectl describe service <service-name>

# Créer un service à partir d’un fichier YAML
kubectl apply -f <service.yaml>

# Supprimer un service
kubectl delete service <service-name>

# Exposer un déploiement en tant que service (par exemple, pour l'accès externe)
kubectl expose deployment <deployment-name> --type=LoadBalancer --name=<service-name>

# Afficher les endpoints associés à un service
kubectl get endpoints <service-name>
```

- Commande sur les volumes

```bash
# Afficher les PersistentVolume (PV) disponibles
kubectl get pv

# Afficher les PersistentVolumeClaims (PVC) dans le namespace actuel
kubectl get pvc

# Décrire un PersistentVolumeClaim
kubectl describe pvc <pvc-name>

# Créer un volume ou PersistentVolumeClaim à partir d’un fichier YAML
kubectl apply -f <volume.yaml>

# Supprimer un PersistentVolumeClaim
kubectl delete pvc <pvc-name>

# Vérifier l'état d'un PersistentVolume
kubectl describe pv <pv-name>
```

- Commande sur les deployments

```bash
# Afficher tous les déploiements dans le namespace actuel
kubectl get deployments

# Afficher tous les déploiements dans tous les namespaces
kubectl get deployments --all-namespaces

# Décrire un déploiement spécifique
kubectl describe deployment <deployment-name>

# Créer un déploiement à partir d’un fichier YAML
kubectl apply -f <deployment.yaml>

# Mettre à jour un déploiement (par exemple, mise à jour d'image dans le fichier YAML)
kubectl apply -f <deployment.yaml>

# Supprimer un déploiement
kubectl delete deployment <deployment-name>

# Mettre à l'échelle un déploiement pour augmenter ou diminuer le nombre de réplicas
kubectl scale deployment <deployment-name> --replicas=<number>

# Obtenir l’historique de révision d'un déploiement
kubectl rollout history deployment <deployment-name>

# Annuler la dernière mise à jour d'un déploiement (rollback)
kubectl rollout undo deployment <deployment-name>

# Redémarrer un déploiement (Rolling restart pour appliquer des mises à jour sans interruptions)
kubectl rollout restart deployment <deployment-name>

# Afficher le statut de progression d'un déploiement
kubectl rollout status deployment <deployment-name>
```

## Déploiement sur K8S

