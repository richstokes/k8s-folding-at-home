# k8s-fah
**Run folding@home on Kubernetes**.

The folding@home project recently added support for the Corona virus (2019-nCoV). 

https://foldingathome.org/2020/02/27/foldinghome-takes-up-the-fight-against-covid-19-2019-ncov/


This deployment lets you run folding@home on Kubernetes, should you have any spare cluster-power you'd like to donate. 

<u>Note</u>: COVID-19 work units are currently being prioritized, however the folding@home client is liable to select jobs for other diseases too.  

If/when they add an option to work only on COVID-19, I will update the deployment here to do so (until the pandemic is over).

&nbsp;

# Overview
There are options to run this on CPU, GPU or a combination of both.  

To use these deployment sets that uses GPU's to fold with,  I assume that you have a working k8s cluster that have nodes with either 1 or more NVIDIA GPUs in them. (AMD have not been tested). 

We are using the same prerequisites as the [k8s-device-plugin](https://github.com/NVIDIA/k8s-device-plugin)

* NVIDIA drivers ~= 384.81
* nvidia-docker version > 2.0 (see how to [install](https://github.com/NVIDIA/nvidia-docker) and it's [prerequisites](https://github.com/nvidia/nvidia-docker/wiki/Installation-\(version-2.0\)#prerequisites))
* docker configured with nvidia as the [default runtime](https://github.com/NVIDIA/nvidia-docker/wiki/Advanced-topics#default-runtime).
* Kubernetes version >= 1.10

&nbsp;

## Installation modes

### Only CPU
> *The default install deploys 2 replicas, limited to using 1 CPU core each.*
> 
```bash
kubectl apply -f https://raw.githubusercontent.com/richstokes/k8s-fah/master/folding-cpu.yaml
```

### Only GPU (Nvidia)
> *The default install deploys 2 replicas, limited to using 1 GPU in each pod.*
> 
```bash
kubectl apply -f https://raw.githubusercontent.com/richstokes/k8s-fah/master/folding-gpu.yaml
```

### Both CPU & GPU (Nvidia)
```bash
kubectl apply -f https://raw.githubusercontent.com/richstokes/k8s-fah/master/folding-gpu-cpu.yaml
```
&nbsp;

### Tested GPU's:
* NVIDIA 
  * NVIDIA GeForce GTX 1080
  * GeForce RTX 2080
  * Tesla K40m
  * Tesla K80
  * V100
* AMD
  * ... If you have tested this on AMD GPU's, please make a PR accordingly and update the list!

&nbsp;

## Rancher
If you have Rancher, you can easily install by searching for "folding" in your Rancher app catalog.

&nbsp;


## DaemonSet

You can also run this as a DaemonSet (runs one replica per node) with:  

```kubectl apply -f https://raw.githubusercontent.com/richstokes/k8s-fah/master/folding-daemonset.yaml```    

There is a `tolerations` section in this .yaml you can uncomment in order to also run FAHClient on master nodes if you wish.  

To enable GPU with the daemon set, uncomment the `nvidia.com/gpu: "1"` lines from `folding-daemonset.yaml` before applying.

&nbsp;


# Customizing

Set the replica count and resource limit as appropriate depending on how much CPU you wish to donate. In my testing, memory load has been reasonably low (<512Mi).  

I've also added the framework for a `PriorityClass`, so that K8s may preemptively evict folding@home pods if a higher-priority pod needs resources.


&nbsp;


## config.xml

The most compatible way to edit the config.xml is by modifying it's values and creating your own Docker image.  

You *can* override/mount as a configMap in Kubernetes (you can see the scaffolding for this inside the manifests), however FAHClient seems to what to copy/move this file around, which doesn't work if the file is mounted.  

You'll get a bunch of errors from the FAHClient if you do this - there may be a better way to manage the config file - PRs welcome!

&nbsp;


# Credits

Special thanks to [Bendik](https://github.com/skandix) for his work on supporting GPUs and general tweaks to the configs.
