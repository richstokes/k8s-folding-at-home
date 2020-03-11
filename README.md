# k8s-fah
Run folding@home on Kubernetes.

The folding project recently added support for the Corona virus (2019-nCoV). 

https://foldingathome.org/2020/02/27/foldinghome-takes-up-the-fight-against-covid-19-2019-ncov/


This is a quick deployment that lets you run this on Kubernetes, should you have any spare cluster-power you'd like to donate. 

Please note, the folding@home client is liable to select jobs for other diseases too. If/when they add an option to work only on COVID-19, I will update the deployment here to do so.

&nbsp;

# Install
```kubectl apply -f https://raw.githubusercontent.com/richstokes/k8s-fah/master/folding.yaml```  

The default install deploys 2 replicas, limited to using 1 CPU core each. 


&nbsp;

# Customizing

I've added the framework for a `PriorityClass`, so that K8s will preemptively evict these pods if a higher-priority one comes along.

And of course set the resource limit as appropriate depending on how much CPU you wish to donate. In my testing, memory load has been very low (<256Mi)