# Vagrant Single Node Kubernetes Cluster

Stupidly simple `Vagrantfile` for creating a single node cluster on VirtualBox
or Hyper-V with [rke](https://github.com/rancher/rke).

## Requirements

- Vagrant

- VirtualBox or Hyper-V

## Run

First change needed memory and CPU amount accordingly in `Vagrantfile`. These
defaults to 8192 MB for memory and 8 CPUs.

After that run:

``` shell
$ vagrant up --provider virtualbox
# OR
$ vagrant up --provider hyperv
```

After it has created the virtual machine you should have
`kube_config_cluster.yml` in your current directroy. This is your newly made
Kubernetes' configurations. You can then do symbolic link to default
`KUBECONFIG` location (or point `KUBECONFIG` to this directory):

``` shell
# You should backup already existing config, if you happen to have one, before
# running this 

$ ln -s kube_config_cluster.yml ~/.kube/config
```

Then you can test if your cluster is created correctly by running:

``` shell
$ kubectl cluster-info
```

If it shows that Kubernetes Master and KubeDNS is running on some address, then
you should be fine.
