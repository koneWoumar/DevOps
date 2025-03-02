######### 0-Mise à jour de mon systeme (ubuntu 18.0.4)
#activaton de cgroup 2
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub
sudo update-grub
#mise à jour du noyau
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install linux-generic-hwe-18.04
sudo reboot
######################################################################################





#1-prerequis
#####################################################################################
echo "****** setting up prerequis ******"
#####################################################################################
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF
# Apply sysctl params without reboot
sudo sysctl --system
sysctl net.ipv4.ip_forward
######################################################################################





#2-docker installation
#####################################################################################
echo "****** Installing containerd runtime ******"
#####################################################################################
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install containerd.io
#####################################################################################





# 3-configure containerd to use systemd as cgroup driver
#####################################################################################
echo "****** Configuring Cgroup driver for containerd ******"
#####################################################################################
sudo containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sed 's|sandbox_image = "registry.k8s.io/pause:3.6"|sandbox_image = "registry.k8s.io/pause:3.10"|' | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
#####################################################################################





# 4-kubernates component installation
#####################################################################################
echo "****** Installing cluster components ******"
#####################################################################################
sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
# installation now of component
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# enable kubelet service before running kubeadm
# sudo systemctl enable --now kubelet
#####################################################################################





# 5-initializing the cluster
#####################################################################################
echo "****** Initializing the cluster ******"
#####################################################################################
# kubeadm init --config kubeadm-config.yaml
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-cert-extra-sans=127.0.0.1,9.12.93.179,10.10.93.114
####################################################################################





########## 6-configuration of kubectl on the node
#####################################################################################
echo "****** Configuring Kubectl key to get access to the cluster ******"
#####################################################################################
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#####################################################################################





######## 7-installation of network pluging for the cluster
#####################################################################################
echo "****** Installing a network pluging for the cluster ******"
#####################################################################################
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
#####################################################################################





########## 8-Remove taint from the controle node to let it run normal pod
#####################################################################################
echo "****** Remove taint from the control node ******"
#####################################################################################
kubectl taint nodes kube-machine node-role.kubernetes.io/control-plane:NoSchedule-
#####################################################################################






########## 9-Remove taint from the controle node to let it run normal pod
# https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md
#####################################################################################
echo "****** installing nginx-ingress-controler ******"
#####################################################################################
kubectl create namespace ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml
#####################################################################################


















##############################################################################################################################################

# Brouillons :



# to reset the cluster and initialize again
    #  sudo kubeadm reset   
    # the take again from the point 5

# detinté le node plane (neud de control pour permetre l'execution de pods normal sur ce neud) :
# kubectl taint nodes kube-machine node-role.kubernetes.io/control-plane:NoSchedule-



# sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=9.12.93.179 --apiserver-cert-extra-sans=127.0.0.1,9.12.93.179,10.10.93.114  #
