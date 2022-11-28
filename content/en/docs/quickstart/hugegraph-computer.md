---
title: "HugeGraph-Computer Quick Start"
linkTitle: "Analysis with HugeGraph-Computer"
weight: 7
---

## 1 HugeGraph-Computer Overview

The [`HugeGraph-Computer`](https://github.com/apache/incubator-hugegraph-computer) is a distributed graph processing system for HugeGraph (OLAP). It is an implementation of [Pregel](https://kowshik.github.io/JPregel/pregel_paper.pdf). It runs on Kubernetes framework.

### Features

- Support distributed MPP graph computing, and integrates with HugeGraph as graph input/output storage.
- Based on BSP(Bulk Synchronous Parallel) model, an algorithm performs computing through multiple parallel iterations, every iteration is a superstep.
- Auto memory management. The framework will never be OOM(Out of Memory) since it will split some data to disk if it doesn't have enough memory to hold all the data.
- The part of edges or the messages of super node can be in memory, so you will never lose it.
- You can load the data from HDFS or HugeGraph, or any other system.
- You can output the results to HDFS or HugeGraph, or any other system.
- Easy to develop a new algorithm. You just need to focus on a vertex only processing just like as in a single server, without worrying about message transfer and memory/storage management.

## 2 Get Started

### 2.1 Run PageRank algorithm locally

> To run algorithm with HugeGraph-Computer, you need to install 64-bit JRE/JDK 11 or later versions.
>
> You also need to deploy HugeGraph-Server and [Etcd](https://etcd.io/docs/v3.5/quickstart/).

There are two ways to get HugeGraph-Computer:

- Download the compiled tarball
- Clone source code then compile and package

#### 2.1 Download the compiled archive

Download the latest version of the HugeGraph-Computer release package:

```bash
wget https://github.com/apache/hugegraph-computer/releases/download/v${version}/hugegraph-loader-${version}.tar.gz
tar zxvf hugegraph-computer-${version}.tar.gz
```

#### 2.2 Clone source code to compile and package

Clone the latest version of HugeGraph-Computer source package:

```bash
$ git clone https://github.com/apache/hugegraph-computer.git
```

Compile and generate tar package:

```bash
cd hugegraph-computer
mvn clean package -DskipTests
```

#### 2.3 Start master node

> You can use `-c`  parameter specify the configuration file, more computer config please see:[Computer Config Options](/docs/config/config-computer#computer-config-options)

```bash
cd hugegraph-computer-${version}
bin/start-computer.sh -d local -r master
```

#### 2.4 Start worker node

```
bin/start-computer.sh -d local -r worker
```

#### 2.5 Query algorithm results

2.5.1 Enable `OLAP` index query for server

If OLAP index is not enabled, it needs to enable, more reference: [modify-graphs-read-mode](/docs/clients/restful-api/graphs/#634-modify-graphs-read-mode-this-operation-requires-administrator-privileges)

```http
PUT http://localhost:8080/graphs/hugegraph/graph_read_mode

"ALL"
```

2.5.2 Query `page_rank` property value:

```bash
curl "http://localhost:8080/graphs/hugegraph/graph/vertices?page&limit=3" | gunzip
```

### 2.2 Run PageRank algorithm in Kubernetes

> To run algorithm with HugeGraph-Computer you need to deploy HugeGraph-Server first

#### 2.2.1 Install HugeGraph-Computer CRD

```bash
# Kubernetes version >= v1.16
kubectl apply -f https://raw.githubusercontent.com/apache/hugegraph-computer/master/computer-k8s-operator/manifest/hugegraph-computer-crd.v1.yaml

# Kubernetes version < v1.16
kubectl apply -f https://raw.githubusercontent.com/apache/hugegraph-computer/master/computer-k8s-operator/manifest/hugegraph-computer-crd.v1beta1.yaml
```

#### 2.2.2 Show CRD

```bash
kubectl get crd

NAME                                        CREATED AT
hugegraphcomputerjobs.hugegraph.apache.org   2021-09-16T08:01:08Z
```

#### 2.2.3 Install hugegraph-computer-operator&etcd-server

```bash
kubectl apply -f https://raw.githubusercontent.com/apache/hugegraph-computer/master/computer-k8s-operator/manifest/hugegraph-computer-operator.yaml
```

#### 2.2.4 Wait for hugegraph-computer-operator&etcd-server deployment to complete

```bash
kubectl get pod -n hugegraph-computer-operator-system

NAME                                                              READY   STATUS    RESTARTS   AGE
hugegraph-computer-operator-controller-manager-58c5545949-jqvzl   1/1     Running   0          15h
hugegraph-computer-operator-etcd-28lm67jxk5                       1/1     Running   0          15h
```

#### 2.2.5 Submit job

> More computer crd please see: [Computer CRD](/docs/config/config-computer#hugegraph-computer-crd)
>
> More computer config please see: [Computer Config Options](/docs/config/config-computer#computer-config-options)

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.apache.org/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobName pagerank-sample
spec:
  jobId: *jobName
  algorithmName: page_rank
  image: hugegraph/hugegraph-computer:latest # algorithm image url
  jarFile: /hugegraph/hugegraph-computer/algorithm/builtin-algorithm.jar # algorithm jar path
  pullPolicy: Always
  workerCpu: "4"
  workerMemory: "4Gi"
  workerInstances: 5
  computerConf:
    job.partitions_count: "20"
    algorithm.params_class: org.apache.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams
    hugegraph.url: http://${hugegraph-server-host}:${hugegraph-server-port} # hugegraph server url
    hugegraph.name: hugegraph # hugegraph graph name
EOF
```

#### 2.2.6 Show job

```bash
kubectl get hcjob/pagerank-sample -n hugegraph-computer-system

NAME               JOBID              JOBSTATUS
pagerank-sample    pagerank-sample    RUNNING
```

#### 2.2.7 Show log of nodes

```bash
# Show the master log
kubectl logs -l component=pagerank-sample-master -n hugegraph-computer-system

# Show the worker log
kubectl logs -l component=pagerank-sample-worker -n hugegraph-computer-system

# Show diagnostic log of a job
# NOTE: diagnostic log exist only when the job fails, and it will only be saved for one hour.
kubectl get event --field-selector reason=ComputerJobFailed --field-selector involvedObject.name=pagerank-sample -n hugegraph-computer-system
```

#### 2.2.8 Show success event of a job

> NOTE: it will only be saved for one hour

```bash
kubectl get event --field-selector reason=ComputerJobSucceed --field-selector involvedObject.name=pagerank-sample -n hugegraph-computer-system
```

#### 2.2.9 Query algorithm results

If the output to `Hugegraph-Server` is consistent with Locally, if output to `HDFS`, please check the result file in the directory of `/hugegraph-computer/results/{jobId}` directory.

## 3 Built-In algorithms document

### 3.1 Supported algorithms list:

###### Centrality Algorithm:

* PageRank
* BetweennessCentrality
* ClosenessCentrality
* DegreeCentrality

###### Community Algorithm:

* ClusteringCoefficient
* Kcore
* Lpa
* TriangleCount
* Wcc

###### Path Algorithm:

* RingsDetection
* RingsDetectionWithFilter

More algorithms please see: [Built-In algorithms](https://github.com/apache/hugegraph-computer/tree/master/computer-algorithm/src/main/java/org/apache/hugegraph/computer/algorithm)

### 3.2 Algorithm describe

TODO

## 4 Algorithm development guide

TODO