# Kubernetes Setup Documentation

This folder contains configuration for deploying **Front-end** , **Back-end** application and also the **Service deployment** file. 


### Files:
- **`config.yml`**: Defines ConfigMaps for environment variables used by the backend and frontend.
- **`deployment.yml`**: Contains Deployment configurations for the backend and frontend applications.
- **`service.yml`**: Defines Services for exposing the backend and frontend applications.
- **`README.md`**: Documentation for setting up Kubernetes resources.

### Key Commands:

### To Connect to EKS Cluster(First Time Setup):

##### Update kubeconfig to connect kubectl to your new EKS cluster:
```
aws eks update-kubeconfig --region <region> --name <cluster-name>
```

#### Verify cluster access:
```
kubectl get nodes
```

#### If you see EC2 nodes →  you're talking to the right EKS cluster

These nodes are your worker nodes

- Apply all Kubernetes manifests:
  ```
  kubectl apply -f .
  ```