# Benchmarking Azure Files with FIO on AKS

## Overview

Azure Files is Microsoft Azure's managed  cloud file system that offers customers the ability to mount file shares from the cloud or on-premises while leveraging SMB and NFS protocols. This repo contains several deployments scripts that enable an end-user to conduct file throughput and IOPS performance tests on a single Azure Files share.

## Artifacts

This repo contains several artifacts to enable a the deployment of full test bed with several clients running on AKS to stress test Azure Files.

* A Terraform script that deploys an AKS Cluster and Azure Files (NFS or SMB can be selected via a variable setting)
* A prepacked Helm Chart that deploys fio with several clients
* A DockerFile containing the shell script to build and/or customize the Docker image to push to a local container repo of your choice

## Deployment

### Prerequisites

This deployment assumes that you have an Azure subscription with owner privileges. This setup deploys several Azure Resources and grants RBAC roles to Managed Identities to successfully run an end-to-end test.

