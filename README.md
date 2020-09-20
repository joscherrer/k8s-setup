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
k8s_public_ip="$(curl https://ifconfig.me/ip)" # Or set this manually
k8s_encryption_key="$(head -c 32 /dev/urandom | base64)"
ansible-playbook -i hosts.yaml site.yaml \
                 -e "k8s_public_ip=${k8s_public_ip},k8s_encryption_key=${k8s_encryption_key}"
```

## pod-cidrs

```text
wrk-001 10.200.1.0/24
wrk-002 10.200.2.0/24
wrk-003 10.200.3.0/24
```


