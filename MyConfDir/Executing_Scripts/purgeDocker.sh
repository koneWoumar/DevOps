#!/bin/bash

# Arrêter tous les conteneurs en cours d'exécution
echo "Arrêt des conteneurs en cours..."
docker stop $(docker ps -aq)

# Supprimer tous les conteneurs
echo "Suppression des conteneurs..."
docker rm $(docker ps -aq)

# Supprimer toutes les images Docker
echo "Suppression des images..."
docker rmi $(docker images -aq)

# Supprimer tous les volumes non utilisés
echo "Suppression des volumes non utilisés..."
docker volume prune -f

# Supprimer tous les réseaux non utilisés
echo "Suppression des réseaux non utilisés..."
docker network prune -f

# Supprimer les images et conteneurs orphelins (dangling)
echo "Suppression des images orphelines..."
docker image prune -a -f

# Supprimer tous les volumes
echo "Suppression de tous les volumes..."
docker volume rm $(docker volume ls -q)

# Nettoyage des données du Docker
echo "Nettoyage des données et fichiers de Docker..."
rm -rf /var/lib/docker/*

echo "Purge Docker terminée!"

