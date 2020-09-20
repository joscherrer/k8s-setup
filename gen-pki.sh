#!/bin/sh
gen_cert() {
    local _name=$1
    shift
    echo "\
    cfssl gencert
        -ca=pki/ca.pem
        -ca-key=pki/ca-key.pem
        -config=json/ca-config.json
        -profile=kubernetes
        $@
        json/${_name}-csr.json | cfssljson -bare pki/${_name}
    "
    cfssl gencert \
        -ca=pki/ca.pem \
        -ca-key=pki/ca-key.pem \
        -config=json/ca-config.json \
        -profile=kubernetes \
        $@ \
        json/${_name}-csr.json | cfssljson -bare pki/${_name}
}

cfssl gencert -initca json/ca-csr.json | cfssljson -bare pki/ca

for instance in k8s-wrk-001 k8s-wrk-002 k8s-wrk-003; do
    _fqdn="${instance}.kvm.bbrain.io"
    cat > json/${_fqdn}-csr.json <<EOF
    {
        "CN": "system:node:${_fqdn}",
        "key": {
            "algo": "rsa",
            "size": 2048
        },
        "names": [
            {
                "C": "FR",
                "L": "Strasbourg",
                "O": "system:nodes",
                "OU": "P",
                "ST": "Alsace"
            }
        ]
    }
EOF
    _ip=$(dig ${_fqdn} +short)
    gen_cert "${_fqdn}" -hostname=${_fqdn},${_ip}
done

gen_cert admin
gen_cert kube-controller-manager
gen_cert kube-proxy
gen_cert kube-scheduler

_k8s_public_ip="91.121.209.92"
_k8s_hostnames="kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local"
_k8s_ips="$(echo $(for i in {1..3}; do dig +short k8s-wrk-00$i.kvm.bbrain.io; done) | tr ' ' ',')"

gen_cert kubernetes -hostname=$_k8s_ips,$_k8s_public_ip,$_k8s_hostnames,127.0.0.1,10.32.0.1
gen_cert service-account
