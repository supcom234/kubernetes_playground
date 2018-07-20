#!/bin/bash
PROJECT_ROOT="/TFPlenum"

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

function configure_master(){
	kubeadm init --apiserver-advertise-address 192.168.50.10
	mkdir -p /home/vagrant/.kube
	cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
	chown -R vagrant:vagrant /home/vagrant/.kube/
	su -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml" vagrant
	local fingerprint=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')	
	local token=$(kubeadm token create)
	echo "${fingerprint}" > /TFPlenum/hash.txt
	echo "${token}" > /TFPlenum/token.txt

    echo "kubectl get nodes"
    kubectl get nodes
	kubectl get pods --all-namespaces
}

install_docker
install_kubernetes
configure_master