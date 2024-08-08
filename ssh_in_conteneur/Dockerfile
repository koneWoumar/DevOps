# Ubuntu comme image de base
FROM ubuntu:latest

# Installer OpenSSH Server
RUN apt-get update && \
    apt-get install -y openssh-server

# Créer un répertoire pour les clés SSH
RUN mkdir /var/run/sshd

# Fichier de configuration
RUN echo 'PasswordAuthentication yes' > /etc/ssh/ssh_config.d/config_file.conf


# Ajouter un utilisateur avec un mot de passe (remplacez 'password' par un mot de passe sécurisé)
RUN useradd -m -s /bin/bash worker && \
    echo 'worker:password' | chpasswd

# Exposer le port 22 pour SSH
EXPOSE 22

# Démarrer le serveur SSH
CMD ["/usr/sbin/sshd", "-D"]