# Kubespray Tutorial

## Description

This repo was created to demonstrate the deployment of kubernetes via [kubespray](https://github.com/kubernetes-incubator/kubespray) on a local Cluster, based on VirtualBox VMs.

The idea of this repo is to create a customizable, fully automated script that sets up a kubernetes cluster with properties similar to a production ready cluster, but running locally - without any further user interaction. This cluster can then be used to test payloads of applications.

The scripts generate an n-node (configurable) Cluster in Virtual Box using Vagrant and a small bit of shell script.

This was developed and tested on Windows 10, but should basically work on Linux or Mac the same way as long as Vagrant and VirtualBox are installed.

The script sets up a virtual Linux machine ("ansible") from which the bulk of the installation will happen. Thus the script can be executed on Windows / Linux and Mac respectively without changes. It will also create a configurable number of virtual machines ("test-kubea1..n) for the kubernetes cluster automatically using Vagrant. These are then installed and configured via Ansible from the first Linux machine.

## Prerequisites

* [Git](https://git-scm.com/downloads)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Minumum 8 GB RAM.

## Usage

Clone this Repo:

```bash
git clone https://github.com/tobiaswaggoner/kubespray
```

Run the init script (on Windows use a *nix terminal which can execute the .sh - Git Bash will do the job):

```bash
./init.sh
```

The script will execute the following steps

1. Create a new key file via ssh-keygen locally which will later be allow the ansible machine to access the kubernetes machines
2. Create the x Kubernetes Machines via Vagrant
    * Copy the public key to authorized_hosts and disable swapping (Required for Kubernetes)
3. Create the Ansible machine via Vagrant
    * Copy the configuration from kubespray-config/test-kubea
    * Clone Kubespray from Github
    * Install and update pip
    * Install all requirements for Kubespray (includes Ansible)
    * Collect and auto accept all hostkeys from the kubernetes nodes
4. Install the cluster via kubespray
5. Create a service account admin-user and grant it admin privileges
6. Create a demo nginx deployment
7. Export the token to vagrant-boxes/cert/ for convenience

This process takes about 40 Minutes on my rather new Notebook with rather slow Internet connection

After it is done you can access the demo nginx on [http://10.0.0.11:30080](http://10.0.0.11:30080)

The Kubernetes Dashboard is available on [https://10.0.0.11:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login](https://10.0.0.11:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/loginl)
--> Use the token in **_vagrant-boxes/cert/dashboardaccesstoken** to access the dasboard.

To access the cluster from the commandline do 

```bash
vagrant ssh test-kubean1
```

kubectl should be pre-configured for the user vagrant on all boxes, so you can for example check the running nginx pods with

```bash
kubectl get pods
```

## Further plans

This is the basic groundwork to set up a kubernetes cluster via kubespray from scratch. The script can adapted to instead provision kubernetes on a given set of machines by just editing the inventory and not creating additional machines via Vagrant.

Also I want to experiment with different network options and the scaling features of kubespray.
