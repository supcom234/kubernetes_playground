Useful commands to remember:
kubeadm join 192.168.1.162:6443 --token gjpihr.uky46nwmdhv245pr --discovery-token-ca-cert-hash sha256:cd2c42bd3b11ff98b502572beee8439f58be7ec6b989fcd9cce1e881cb20b223

kubeadm join 192.168.1.71:6443 --token hgd1ru.vyays57ml1axdwuy --discovery-token-ca-cert-hash sha256:fc731a887cd4b55f6cf08a791c7e59418961fec983479a51f997c58ef8a4638a

kubectl get nodes
kubectl get pods --all-namespaces

For getting logs on a kubelet:
journalctl -u kubelet

For resetting a node so that it can be repurposed for something else.
kubeadm reset
