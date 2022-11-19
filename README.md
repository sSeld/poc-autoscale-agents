# Autoscale Agents for Azure DevOps

## Getting Started

Required Tools:
- kind
- docker/podman
- kubectl

### Update config

Update the `config.json` file with your prefered values before running the other scripts.

```
SCALE_TYPE = 'job' or 'deployment'
AZP_TOKEN // get this from ADO by creating a personal access token with read & manage scope to Agent Pools
AZP_URL // https://dev.azure.com/<<org>
AZP_POOL // Your Agent Pool name
POOL_ID // The Agent Pools id, found by going to Organization Settings > Agent pools > <<your pool>> ; The pool id should be in the url path

```

### Setup Local Registry for Kind Cluster

Run the `create-registry.ps1` scripts to setup your local registry for kubernetes.

### Build Images

Run the `build.ps1` script to build the agent images to test with.

### Create Cluster

Run the `create-cluster.ps1` script to setup the cluster for the first time. This script will use all the configuration files located in `cluster/`.


### Configure KEDA & Scaled Jobs for your cluster

Run the `configure-keda.ps1` script to setup the scaled job CRD's and KEDA metrics server.

---

# Other Notes

The ADO job queue needs to have at least one agent in the pool in order to successfully queue. If youre using the ScaleJob as your autoscale agents then you need to configure a placeholder agent. This is done through the job config by passing a flag `PLACEHOLDER_AGENT` to the agent and start script to register the placeholder agent in the pool. The placeholder is never meant to come online, it is just a workaround to allow jobs to queue. 

