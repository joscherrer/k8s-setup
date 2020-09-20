# Kubernetes setup

## Prerequisites

- [Create nodes](https://github.com/joscherrer/kvm-scripts)
    - 3 Controllers
    - 3 Workers

- [Setup load-balancer]()

- Create Hosts file
```yaml
all:
  children:
    controllers:
      hosts:
        controller1.example.com:
        controller2.example.com:
        controller3.example.com:
    workers:
      hosts:
        worker1.example.com:
        worker2.example.com:
        worker3.example.com:
```

## Install

```bash
./gen-pki.sh
k8s_public_ip="$(curl https://ipconfig.me/ip)" # Or set this manually
ansible-playbook -i hosts.yaml bootstrap.yaml
ansible-playbook -e "k8s_public_ip=${k8s_public_ip}" -i hosts.yaml distrib_certs.yaml
```

## pod-cidrs

```text
wrk-001 10.200.1.0/24
wrk-002 10.200.2.0/24
wrk-003 10.200.3.0/24
```


