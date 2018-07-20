#!/bin/bash
PROJECT_ROOT="/TFPlenum"
MASTER_IP="192.168.50.10"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

function install_docker(){
	yum install -y docker
	systemctl enable docker
	systemctl start docker
	usermod -a -G docker vagrant
}

function install_kubernetes(){
	cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
	setenforce 0
	yum install -y kubelet kubeadm kubectl
	cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
	sysctl --system	
	swapoff -a
	sed -i '/swap/d' /etc/fstab
	mkdir -p /var/lib/kubelet/
	systemctl enable kubelet 
	systemctl start kubelet	
}

function setup_node(){
    local token="$(cat $PROJECT_ROOT/token.txt)"
    local hash="$(cat $PROJECT_ROOT/hash.txt)"
    echo "Setting up the node!"    
    echo "kubeadm join ${MASTER_IP}:6443 --token ${token} --discovery-token-ca-cert-hash sha256:${hash}"
    #kubeadm join ${MASTER_IP}:6443 --token $(cat $PROJECT_ROOT/token.txt) --discovery-token-ca-cert-hash sha256:$(cat $PROJECT_ROOT/hash.txt)
    kubeadm join ${MASTER_IP}:6443 --token ${token} --discovery-token-ca-cert-hash sha256:${hash}
}

install_docker
install_kubernetes
setup_node