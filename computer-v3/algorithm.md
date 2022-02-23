# 5.Hugegraph-Computer 使用说明

## 5.1.OLAP 算法

### 5.1.1.PageRank 算法

##### 功能介绍

PageRank算法又称网页排名算法，是一种由搜索引擎根据网页（节点）之间相互的超链接进行计算的技术，用来体现网页（节点）的相关性和重要性。
- 如果一个网页被很多其他网页链接到，说明这个网页比较重要，也就是其PageRank值会相对较高。
- 如果一个PageRank值很高的网页链接到其他网页，那么被链接到的网页的PageRank值会相应地提高。

##### 适用场景

PageRank算法适用于网页排序、社交网络重点人物发掘等场景。

##### 参数说明

| 名称                     | 是否必填 |  类型   | 默认值  |取值范围        |  说明                   |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| pagerank.alpha  | 否 |  Double   | 0.15  |0~1，不包括0和1        |  权重系数(又称阻尼系数)         |
| pagerank.l1DiffThreshold  | 否 |  Double   | 0.00001  |0~1，不包括0和1        |  收敛精度,为每次迭代各个点相较于上次迭代变化的绝对值累加和上限，当小于这个值时认为计算收敛，算法停止。         |
| bsp.max_super_step  | 否 |  Int   | 10  |1~2000        |  最大迭代次数         |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId pagerank-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: pagerank # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "page-rank",
  "worker": 5,
  "params": {
    "pagerank.alpha": "0.15",
    "pagerank.l1DiffThreshold": "0.00001",
    "bsp.max_super_step": "10"
  }
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

输出每个顶点的PageRank值，结果类型为浮点数。

### 5.1.2.Weakly Connected Component

##### 功能介绍

弱连通分量，计算无向图中所有联通的子图，输出各顶点所属的弱联通子图id

##### 适用场景

表明各个点之间的连通性，区分不同的连通社区

##### 参数说明

无

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId wcc-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: wcc # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.community.wcc.WccParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "wcc",
  "worker": 5,
  "params": {}
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

输出每个顶点的弱联通子图id值，结果类型为字符串。

### 5.1.3.Degree Centrality

##### 功能介绍

度中心性算法，算法用于计算图中每个节点的度中心性值，支持无向图和有向图。度中心性是衡量节点重要性的重要指标，节点与其它节点的边越多，则节点的度中心性值越大，节点在图中的重要性也就越高。在无向图中，度中心性的计算是基于边信息统计节点出现次数，得出节点的度中心性的值，在有向图中则基于边的方向进行筛选，基于输入边或输出边信息统计节点出现次数，得到节点的入度值或出度值。

##### 适用场景

表明各个点的重要性，一般越重要的点度数越高。

##### 参数说明

| 名称                     | 是否必填 |  类型   | 默认值  |取值范围        |  说明                   |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| degree_centrality.weight_property  | 否 |  String   | "",为空时边权重为1  | -      |  权重属性名         |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId degree-centrality-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: degree_centrality # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.degree.DegreeCentralityParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "degree-centrality",
  "worker": 5,
  "params": {
    "degree_centrality.weight_property": ""
  }
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

输出每个顶点的度中心性的值，结果类型为浮点数。

### 5.1.4.Closeness Centrality

##### 功能介绍

紧密中心度算法（Closeness Centrality）计算一个节点到所有其他可达节点的最短距离的倒数，进行累积后归一化的值。紧密中心度可以用来衡量信息从该节点传输到其他节点的时间长短。节点的 “Closeness Centrality” 越大，其在所在图中的位置越靠近中心。

##### 适用场景

紧密中心度算法（Closeness Centrality）适用于社交网络中关键节点发掘等场景。

##### 性能说明

由于中心性算法属于指数膨胀算法，如果不作限制是跑不下去的，根据硬件资源的情况可调整 sample_rate （采样率）和 limit_edges_in_one_vertex （最大出边限制），以免跑不下去。因为采样能一定程度的表征定点的中心性，所以小采样率不仅可以减少计算量，还可能对最终结果影响比较小。

##### 参数说明

| 名称                     | 是否必填 |  类型   | 默认值  |取值范围        |  说明                   |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| closeness_centrality.weight_property  | 否 |  String   | ""，为空时边权重为1  |  -       |  权重属性名         |
| closeness_centrality.sample_rate  | 否 |  Double   | 1.0  | (0, 1.0]        |  边的采样率  |
| input.limit_edges_in_one_vertex  | 否 |  Int   | -1  | -        |  最大出边限制         |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId closeness-centrality-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: closeness-centrality # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.closeness.ClosenessCentralityParams # 算法配置类
    closeness_centrality.sample_rate: "0.01"
    bsp.max_super_step: "5"
    input.limit_edges_in_one_vertex: "100"
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "closeness-centrality",
  "worker": 5,
  "params": {
    "closeness_centrality.weight_property": "",
    "closeness_centrality.sample_rate": "0.01",
    "input.limit_edges_in_one_vertex": "100",
    "bsp.max_super_step": "5"
  }
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

输出每个顶点的紧密中心性的值，结果类型为浮点数。

### 5.1.5.Triangle Count

##### 功能介绍

三角形计数算法，用于计算通过每个顶点的三角形个数。

##### 适用场景

计算用户之间的关系，关联性是不是成三角形。

##### 性能说明

在三角形计数中，超级点会产生大量的消息，导致磁盘和算力需求非常高，但实际应用中超级点的三角形特别多，求出来没有多少实际意义，所以建议设置限制出边的参数来减少资源和算力消耗。详情见 5.2.4.限制每个点的最大边数。

##### 参数说明

| 名称                     | 是否必填 |  类型   | 默认值  |取值范围        |  说明                   |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| input.limit_edges_in_one_vertex  | 否 |  Int   | -1  | -        |  最大出边限制         |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId trianglecount-test123 # 任务ID
spec:
  jobId: *jobId
  algorithmName: TriangleCount # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.community.trianglecount.TriangleCountParams # 算法配置类
    job.partitions_count: "20" # 分区数
    input.limit_edges_in_one_vertex: "1000"
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "triangle-count",
  "worker": 5,
  "input.limit_edges_in_one_vertex": "1000",
  "params": {}
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

输出每个顶点所属的三角形个值，结果类型为整形。

### 5.1.6.Rings Detection

##### 功能介绍

环路检测算法（Rings Detection），用于检测图中的环路，环路的路径由环路中最小id的顶点来记录。

##### 适用场景

检测有没有循环转账等。

##### 性能说明

由于环路检测算法是一个指数增长的算法，不带条件的环路检测只能跑很小的数据（几十万边），要在大数据集上跑环路检测，请参见带条件的环路检测，用条件把不需要的数据过滤掉。

##### 参数说明

| 名称                     | 是否必填 |  类型   | 默认值  |取值范围        |  说明                   |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| bsp.max_super_step  | 否 |  Int   | 10  |1~2000        |  最大迭代次数         |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId rings-detection # 任务ID
spec:
  jobId: *jobId
  algorithmName: RingsDetection # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.path.rings.RingsDetectionParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    input.edge_freq: "MULTIPLE" # 默认是MULTIPLE，可选范围"SINGLE", "SINGLE_PER_LABEL", "MULTIPLE"。分别代表两点之间只允许有一条边、两点之间同label多条边、两点之间多条边。
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "rings",
  "worker": 5,
  "params": {
    "bsp.max_super_step": "10"
  }
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

结果类型为字符串集合，集合中每一个元素是一个环路。一个环路只会被记录在环路中id最小的顶点上。

### 5.1.7.Filtered Rings Detection

##### 功能介绍

带过滤条件的环路检测算法（Filtered Rings Detection）用于检测图中的环路，环路的路径由环路中最小id的顶点来记录。可通过指定点、边属性过滤规则让算法选择性的做路径传播。

##### 适用场景

检测有没有循环转账等。

##### 性能说明

此算法为指数增长的算法，要用条件限制点和边的数量，不然跑不出来。

##### 参数说明

| 名称                     | 是否必填 |  类型   | 默认值  |取值范围        |  说明                   |
| :----------------------- | :------- | :--------------------- | :----- | :-------------- | :------ |
| bsp.max_super_step  | 否 |  Int   | 10  |1~2000        |  最大迭代次数         |
| rings.property_filter  | 否 |  String   | {}  |  -        |  点边属性过滤条件         |

##### 额外说明

- vertex_filter和edge_filter分别表示点和边的过滤条件，可以为不同label的点边配置不同的过滤规则。相同label的点或边的过滤条件只会保留最后一个。
- vertex_filter和edge_filter可以是非必选的。对于vertex_filter和edge_filter任何一个单独来看，如果没有指定过滤条件的话将对所有对应的元素放行，如果指定了的话，那么只会对label相同并且属性满足条件的放行，未配置label的元素将直接被过滤掉。
- property_filter用于规定属性的过滤规则，在vertex_filter中符合条件的点才会继续向下传播路径，在edge_filter中符合条件的出边才能传播，还可以用入边跟出边之间做属性比较判断过滤。不同label之间是或的关系。
- $element、$out、$in可以理解为内置变量。$element在vertex_filter中表示当前点的属性对象。在edge_filter中$in和$out分别代表表示当前顶点的入边属性和出边属性对象。$element.xxx、$in.xxx、$out.xxx的方式获取到对应名称的属性的值。
- property_filter使用的是Aviator规则引擎。可以支持正常的条件判断和数值计算。高级操作具体查看Aviator规则引擎文档。

##### 过滤条件参数说明

```java
// 需要将这个json进行序列话并转译之后，贴到上面的过滤条件配置中
{
    "vertex_filter": [
        {
            "label": "user",
            "property_filter": "$element.weight==1"
        }
    ],
    "edge_filter": [
        {
            "label": "know",
            "property_filter": "$in.weight==$out.weight"
        }
    ]
}
 
 
// 示例1
{
    "vertex_filter": [
        {
            "label": "user", //点label必须是user，并且weight属性必须等1的点才能放行。其他label和属性不满足的点将无法通过过滤。
            "property_filter": "$element.weight==1"
        }
    ],
    "edge_filter": [
        {
            "label": "know", //边label必须是know，并且入边和出边属性的weight必须相同才放行。其他label和属性不满足的边将无法通过过滤。
            "property_filter": "$in.weight==$out.weight"
        }
    ]
}
 
 
// 示例2：没有指定点的过滤条件，意味着所有的点都可以通过。
{
    "edge_filter": [
        {
            "label": "know", //边label必须是know，并且入边和出边属性的weight必须相同才放行。其他label和属性不满足的边将无法通过过滤。
            "property_filter": "$in.weight==$out.weight"
        }
    ]
}
```

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId filter-rings-detection # 任务ID
spec:
  jobId: *jobId
  algorithmName: RingsDetectionWithPropertyFilter # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.path.rings.filter.RingsDetectionWithFilterParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    input.edge_freq: "MULTIPLE" # 默认是MULTIPLE，可选范围"SINGLE", "SINGLE_PER_LABEL", "MULTIPLE"。分别代表两点之间只允许有一条边、两点之间同label多条边、两点之间多条边。
    rings.property_filter: "{\"vertex_filter\":[{\"label\":\"user\",\"property_filter\":\"$element.weight==1\"}]}"  # 过滤条件规则。配置规则请见下方的过滤条件参数说明，用下面json替换{}部分
EOF
```

##### rest-api 示例

###### Method & Url
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis

###### Request Body

```json
{
  "algorithm": "rings-with-filter",
  "worker": 5,
  "params": {
	"bsp.max_super_step": "10",
	"rings.property_filter": "{\"vertex_filter\":[{\"label\":\"user\",\"property_filter\":\"$element.weight==1\"}]}"
  }
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

结果类型为字符串集合，集合中每一个元素是一个环路。一个环路只会被记录在环路中id最小的顶点上。

### 5.1.8. Links

##### 功能介绍

链路追踪算法，通过指定的一批开始顶点，按照指定的传播规则进行传播，到指定的结束条件后停止并记录下路径。

##### 适用场景

调用链、交易链、营销链等链条的追踪、查询、还原。

##### 参数说明

|  名称   | 是否必填  | 类型  | 默认值 | 取值范围 | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ---- |
| bsp.max_super_step | 否 | Int | 10 | 1-2000 | 最大迭代次数 |
| links.analyze_config  | 是 | String |   |   | 链路传播条件配置 |

##### links.analyze_config 配置说明
|  名称   | 说明  |
|  ----  | ---- |
| start_vertexes | 起始点的配置，值为点的id。算法将从指定的点开始传播路径 |
| vertex_end_condition | 路径传播的点终止条件，可以通过点的属性进行判断，当点的属性满足该条件时，该路径传播将会停止并记录结果。内置$element代表当前顶点，通过$element.属性名称可以获取属性判断是否结束传播。 |
| edge_end_condition | 路径传播的边终止条件，可以通过出边的属性进行判断，当出边的属性满足该条件时，该路径传播就会停止并记录结果。内置$out出边，通过$out.属性名称可以进行属性判断是否结束传播。 |
| edge_compare_condition | 传播条件，可以指定入边和出边的比较条件，当满足该条件时才会继续向下传播，否则会停止传播。内置$out和$in分别代表出边和入边，通过$out.属性名和$in.属性名可以进行出入边的属性计算，符合条件的才会进行传播。其中vertex_end_condition和edge_end_condition可以有一个不设置，但是不能都不设置。|

##### k8s使用示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId links # 任务ID
spec:
  jobId: *jobId
  algorithmName: Links # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.path.links.LinksParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    links.analyze_config: "{\"start_vertexes\":[\"A\",\"B\",\"C\",\"D\",\"E\"],\"vertex_end_condition\":{\"label\":\"user\",\"property_filter\":\"$element.age <= 90\"},\"edge_end_condition\":{\"label\":\"pay\",\"property_filter\":\"double($out.money) >= 4\"},\"edge_compare_condition\":{\"label\":\"pay\",\"property_filter\":\"$out.money > $in.money\"}}"
EOF

```

##### rest-api 示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request body

```json
{
  "algorithm": "links",
  "worker": 5,
  "params": {
    "bsp.max_super_step": "10",
    "links.analyze_config": "{\"start_vertexes\":[\"A\",\"B\",\"C\",\"D\",\"E\"],\"vertex_end_condition\":{\"label\":\"user\",\"property_filter\":\"$element.age <= 90\"},\"edge_end_condition\":{\"label\":\"pay\",\"property_filter\":\"double($out.money) >= 4\"},\"edge_compare_condition\":{\"label\":\"pay\",\"property_filter\":\"$out.money > $in.money\"}}"
  }
}
```

###### Response Body

```
{
  "task_id": "7"
}
```

##### 输出

图中顶点的会添加名为rings_with_filter的属性，该属性记录是链路信息。结果类型为字符串集合，集合中每一个元素是一个链路。链路会被记录到链路结束的那个顶点上。

### 5.1.9. Cluster Coefficient

##### 概述

聚集系数，计算每个点局部的聚集系数, 暂时未提供全局聚集系数。

##### 适用场景

聚类系数算法（Cluster Coefficient）适用于衡量图的结构特性场景。

##### 参数说明

无

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId test-lcc # 任务ID
spec:
  jobId: *jobId
  algorithmName: ClusteringCoefficient # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.community.cc.ClusteringCoefficientParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF

```

##### rest-api  示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request Body

```json
{
  "algorithm": "clustering-coefficient",
  "worker": 5,
  "params": {}
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

图中顶点的会添加名为clustering_coefficient的属性，该属性的值是顶点的聚集系数的值。结果类型为浮点数。

### 5.1.10. Betweenness Centrality

##### 概述

中介中心性算法（Betweeness Centrality）判断一个节点具有"桥梁"节点的值, 值越大说明它作为图中两点间必经路径的可能性越大, 典型的例子包括社交网络中的**共同关注**的人

##### 适用场景

衡量社群围绕某个节点的聚集程度

##### 参数说明

| 名称                               | 是否必填 | 类型   | 默认值 | 取值范围 | 说明         |
| ---------------------------------- | -------- | ------ | ------ | -------- | ------------ |
| betweenness_centrality.sample_rate | 否       | Double | 1.0    | (0, 1.0] | 边的采样率   |
| input.limit_edges_in_one_vertex    | 否       | Int    | -1     |          | 最大出边限制 |

##### k8s 示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId test-bc # 任务ID
spec:
  jobId: *jobId
  algorithmName: betweenness_centrality # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams # 算法配置类
    betweenness_centrality.sample_rate: "0.01"
bsp.max_super_step: "5"
input.limit_edges_in_one_vertex: "100"
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request Body

```json
{
  "algorithm": "betweenness-centrality",
  "worker": 5,
  "params": {
  "betweenness_centrality.sample_rate": "0.01",
  "input.limit_edges_in_one_vertex": "100",
    "bsp.max_super_step": "5"
  }
}
```

###### Response Body

```json
"task_id": "7"
```

##### 输出

图中顶点的会添加名为betweenness_centrality的属性，该属性的值是顶点的中介中心性的值。结果类型为浮点数。

### 5.1.11 Label Propagation Algorithm

##### 概述

标签传递算法，是一种图聚类算法，常用在社交网络中。

##### 适用场景

用于发现潜在的社区。

##### 参数说明

无

##### k8s 示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId lpa-test # 任务ID
spec:
  jobId: *jobId
  algorithmName: lpa-test # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.community.lpa.LpaParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### res-api示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request Body

```json
{
  "algorithm": "lpa",
  "worker": 5,
  "params": {}
}
```

###### Response Body

```json
{
  "task_id": "7"
}
```

##### 输出

 图中顶点的会添加名为lpa的属性，该属性的值是顶点所属的标签。结果类型为字符串。

### 5.1.12 Louvain

##### 概述

 Louvain 算法是基于模块度的社区发现算法。由于Louvain算法的特殊性，只用一个worker instance运行。

##### 适用场景

社区发现。

##### 参数说明

无

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId louvain-test # 任务ID
spec:
  jobId: *jobId
  algorithmName: louvain-test # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 1 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.community.louvain.LouvainParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request Body

```json
{
  "algorithm": "louvain",
  "worker": 1,
  "params": {}
}
```

###### 

##### 输出

输出为每个顶点的社区编号

### 5.1.13. Filter SubGraph Matching

##### 概述

带属性过滤的子图匹配算法。用户可以传入一个带属性过滤的查询图结构，算法会在图中匹配所有与该查询图同构的子图。

##### 适用场景

已知某种模式（子图）的情况下，在大数据上查找满足这种模式的样本。

##### 参数

| 名称                        | 是否必填 | 类型   | 默认值 | 取值范围 | 说明                       |
| --------------------------- | -------- | ------ | ------ | -------- | -------------------------- |
| subgraph.query_graph_config | 是       | String |        |          | 查询图配置，json数组字符串 |

##### subgraph.query_graph_config配置说明
| 名称                        |  说明                       | 是否必填 |
| --------------------------- | ------------------------- | -------- |
| json对象 | 每个json对象代表一个点 | 否 |
| id | 为该点在查询图中的顶点id，用于让用户组织查询图结构 | 是 |
| label | 该点在查询图中的label，在算法匹配时会作为条件进行匹配 | 是 |
| property_filter | 为顶点的属性过滤条件 | 否 |
| edges | 以该点作为起点的出边列表，该配置是一个数组，内部每一个json对象表示一个目标点<br>    - targetId为目标点的id（必填）<br>    - label是该条边的label，在子图匹配时会拿来进行边label的匹配（必填）<br/>    - property_filter是边的属性过滤条件，在匹配时边的属性必须满足该条件（非必填） | 否 |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId links # 任务ID
spec:
  jobId: *jobId
  algorithmName: subgraph-match # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.path.subgraph.SubGraphMatchParams # 算法配置类
    job.partitions_count: "20" # 分区数
    hugegraph.name: "hugegraph" # 图名
    subgraph.query_graph_config: "[{\"id\":\"A\",\"label\":\"person\",},	{\"id\":\"B\",\"label\":\"person\",\"property_filter\":\"$element.x > 3\"},{\"id\":\"C\",\"label\":\"person\",\"edges\":[{\"targetId\":\"A\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"}]},{\"id\":\"D\",\"label\":\"person\",\"property_filter\":\"$element.x > 3\",\"edges\":[{\"targetId\":\"B\",\"label\":\"knows\",},{\"targetId\":\"F\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"},{\"targetId\":\"C\",\"label\":\"knows\",},{\"targetId\":\"E\",\"label\":\"knows\",}]},{\"id\":\"E\",\"label\":\"person\",},{\"id\":\"F\",\"label\":\"person\",\"property_filter\":\"$element.x > 3\",\"edges\":[{\"targetId\":\"B\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"},{\"targetId\":\"C\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"}]}]"
EOF
```

##### rest-api 示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Resquest Body

```json
"algorithm": "subgraph-match",
  "worker": 5,
  "params": {
    "subgraph.query_graph_config": "[{\"id\":\"A\",\"label\":\"person\",},{\"id\":\"B\",\"label\":\"person\",\"property_filter\":\"$element.x > 3\"},{\"id\":\"C\",\"label\":\"person\",\"edges\":[{\"targetId\":\"A\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"}]},{\"id\":\"D\",\"label\":\"person\",\"property_filter\":\"$element.x > 3\",\"edges\":[{\"targetId\":\"B\",\"label\":\"knows\",},{\"targetId\":\"F\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"},{\"targetId\":\"C\",\"label\":\"knows\",},{\"targetId\":\"E\",\"label\":\"knows\",}]},{\"id\":\"E\",\"label\":\"person\",},{\"id\":\"F\",\"label\":\"person\",\"property_filter\":\"$element.x > 3\",\"edges\":[{\"targetId\":\"B\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"},{\"targetId\":\"C\",\"label\":\"knows\",\"property_filter\":\"$element.x > 3\"}]}]"
  }
```

###### 过滤条件示例

//需要将这个json压缩并转译之后，贴到上面的subgraph.query_graph_config上
```json
[
    {
        "id": "A",
        "label": "person",
    },
    {
        "id": "B",
        "label": "person",
        "property_filter": "$element.x > 3"
    },
    {
        "id": "C",
        "label": "person",
        "edges": [
            {
                "targetId": "A",
                "label": "knows",
                "property_filter": "$element.x > 3"
            }
        ]
    },
    {
        "id": "D",
        "label": "person",
        "property_filter": "$element.x > 3",
        "edges": [
            {
                "targetId": "B",
                "label": "knows",
            },
            {
                "targetId": "F",
                "label": "knows",
                "property_filter": "$element.x > 3"
            },
            {
                "targetId": "C",
                "label": "knows",
            },
            {
                "targetId": "E",
                "label": "knows",
            }
        ]
    },
    {
        "id": "E",
        "label": "person",
    },
    {
        "id": "F",
        "label": "person",
        "property_filter": "$element.x > 3",
        "edges": [
            {
                "targetId": "B",
                "label": "knows",
                "property_filter": "$element.x > 3"
            },
            {
                "targetId": "C",
                "label": "knows",
                "property_filter": "$element.x > 3"
            }
        ]
    }
]
```

##### 输出

算法会从查询图中找出一个中心点，子图结果会在匹配中心点的顶点上输出，输出结果是一个顶点id的列表，表示哪些顶点是一个匹配的子图。

### 5.1.14. K-Core

##### 概述

K-Core算法，标记所有度数为K的顶点。

##### 适用场景

图的剪枝，查找图的核心部分。

##### 参数说明

| 名称    | 是否必填 | 类型 | 默认值 | 取值范围 | 说明                              |
| ------- | -------- | ---- | ------ | -------- | --------------------------------- |
| kcore.k | 否       | Int  | 3      |          | K-Core算法的k值，非必需，有默认值 |

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId subgraphmatch # 任务ID
spec:
  jobId: *jobId
  algorithmName: SubGraphMatch # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.community.kcore.KCoreParams # 算法配置类
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    kcore.k: "3" # k-core算法的k值
```

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request Body

```json
{
  "algorithm": "k-core",
  "worker": 5,
  "params": {
    "kcore.k": "3"
  }
}
```

##### 输出

算法会给所有符合条件的顶点标记上对应的core值，core值小于k的顶点的结果为0。

### 5.1.15. PersonalPageRank

##### 概述

   PersonalPageRank 算法又称个性化推荐算法，是一种由搜索引擎根据网页（节点）之间相互的超链接进行计算的技术，用来体现网页（节点）的相关性和重要性, 其他说明和介绍详见 [TP 部分]

   它可以计算出两类不同顶点连接形成的二分图中，给某个点推荐相关性最高的其他顶点，例如：

- 阅读推荐：找出优先给某人推荐的其他书籍 ,     也可以同时推荐共同喜好最高的书友 (例：微信 "你的好友也在看 xx 文章" 功能)
- 社交推荐：找出拥有相同关注话题的其他博主 ,     也可以推荐可能感兴趣的新闻 / 消息 (例: Weibo 中的 "热点推荐" 功能)
- 商品推荐：通过某人现在的购物习惯，找出应优先推给它的商品列表 ,     也可以给它推荐带货播主 (例: TaoBao 的 "猜你喜欢" 功能)

##### 适用场景

PersonalPageRank 算法同样适用于随机游走、社交网络重点人物发掘等场景，偏推荐。

##### 参数说明

| 名称                   | 是否必填 | 类型    | 默认值  | 取值范围          | 说明                       |
| ---------------------- | -------- | ------- | ------- | ----------------- | -------------------------- |
| ppr.alpha              | 否       | Double  | 0.85    | (0, 1)            | 权重系数(又称阻尼系数)     |
| ppr.l1DiffThreshold    | 否       | Double  | 0.00001 | (0, 1)            | 收敛精度                   |
| ppr.source             | 是       | String  | /       | 合法存在的 顶点id | 起始顶点                   |
| bsp.max_super_step     | 否       | Int     | 10      | 1-2000            | 最大迭代次数               |
| input.use_id_fixlength | 否       | Boolean | true    | true, false       | true时，系统采用自增id运算 |

##### 参数含义

- alpha决定跳转概率系数，也称为阻尼系数，是算法内的计算控制变量。
- l1DiffThreshold为每次迭代各个点相较于上次迭代变化的绝对值累加和上限，当小于这个值时认为计算收敛，算法停止。
- 收敛精度（l1DiffThreshold）设置较大值时，迭代会较快停止。

##### k8s示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId ppr-task # 任务ID
spec:
  jobId: *jobId
  algorithmName: ppr # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.ppr.PersonalPageRankParams # 算法配置类
    ppr.source: "1:tom" # source vid
    job.partitions_count: "20" # 分区数
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
EOF
```

##### rest-api 示例

###### Method & Url

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

###### Request Body

```json
{
  "algorithm": "ppr",
  "worker": 5,
  "params": {
    "ppr.alpha": "0.15",
    "ppr.l1DiffThreshold": "0.001",
    "ppr.source": "1:tom"
  }
}
```

##### 输出

顶点的 personal page rank 值

## 5.2.全局配置

### 5.2.1.Hdfs 输出配置

##### 参数说明

| **参数**                       | **是否必选** | **说明**                                     | **默认值**                                               |
| ------------------------------ | ------------ | -------------------------------------------- | -------------------------------------------------------- |
| output.output_class            | 是           | 输出类                                       | com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput |
| output.hdfs_core_site_path     | 否           | hdfs core-site.xml 路径                      |                                                          |
| output.hdfs_site_path          | 是           | hdfs hdfs-site.xml 路径可覆盖output.hdfs_url |                                                          |
| output.hdfs_url                | 否           | Hdfs地址                                     | hdfs://127.0.0.1:9000                                    |
| output.hdfs_user               | 否           | Hdfs用户                                     | hadoop                                                   |
| output.hdfs_path_prefix        | 否           | Hdfs结果文件夹前缀                           | /hugegraph-computer/results                              |
| output.hdfs_delimiter          | 否           | Hdfs结果文件分割符                           | ,                                                        |
| output.hdfs_merge_partitions   | 否           | 是否将输出结果合并成一个文件                 | true                                                     |
| output.hdfs_kerberos_enable    | 否           | 是否开启kerbero认证                          | false                                                    |
| output.hdfs_krb5_conf          | 否           | krb5_conf 文件路径                           | /etc/krb5.conf                                           |
| output.hdfs_kerberos_principal | 否           | kerberos_principal                           |                                                          |
| output.hdfs_kerberos_keytab    | 否           | keytab 文件路径                              |                                                          |

**以 pagerank为例**

```
# 创建 hdfs-config-map

kubectl create configmap hdfs-conf --from-file=./core-site.xml --from-file=./hdfs-site.xml -n hugegraph-computer-system
```

```
# 创建 kerberos-secret

kubectl create secret generic kerberos-secret --from-file=/etc/krb5.conf --from-file=/etc/security/keytab/nn.service.keytab -n hugegraph-computer-system
```

```yaml
cat <<EOF | kubectl apply --filename -

apiVersion: hugegraph.baidu.com/v1

kind: HugeGraphComputerJob

metadata:

 namespace: hugegraph-computer-system

 name: &jobId trianglecount-test123 # 任务ID

spec:

 jobId: *jobId

 algorithmName: TriangleCount # 算法名

 image: xxxxx/xxxxx:latest # 算法镜像地址

 pullPolicy: Always # 是否重新拉取镜像

 workerInstances: 10 # worker 实例数

 secretPaths: # 挂载 secret 到容器目录

  kerberos-secret: /opt/kerberos-secret

 configMapPaths: # 挂载 configmap 到容器目录

  hdfs-conf: /opt/hdfs_conf

 computerConf:

  algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams  # 算法配置类

  job.partitions_count: "20" # 分区数

   pd.peers: "127.0.0.1:8686"  # pd 地址
   
   hugegraph.name: "default/hugegraph" # 图空间/图名

  output.output_class: com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput

  output.hdfs_kerberos_enable: "true"

  output.hdfs_path_prefix: /hugegraph-computer/results

  output.hdfs_kerberos_principal: nn/localhost@ESRICHINA.COM

  output.hdfs_krb5_conf: /opt/kerberos-secret/krb5.conf

  output.hdfs_kerberos_keytab: /opt/kerberos-secret/nn.service.keytab

  output.hdfs_core_site_path: /opt/hdfs_conf/core-site.xml

  output.hdfs_site_path: /opt/hdfs_conf/hdfs-site.xml

EOF
```

##### rest-api 示例

**Method & Url**

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

**Request Body** 

```json
{

 "algorithm": "page-rank",

 "worker": 5,

 "params": {

  "output.output_class": "com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput",

  "bsp.max_super_step": "10",

  "output.hdfs_kerberos_enable": "true",

  "output.hdfs_path_prefix": "/hugegraph-computer/results",

  "output.hdfs_kerberos_principal": "nn/localhost@ESRICHINA.COM",

  "output.hdfs_krb5_conf": "/opt/kerberos-secret/krb5.conf",

  "output.hdfs_kerberos_keytab": "/opt/kerberos-secret/nn.service.keytab",

  "k8s.secret_paths": "[kerberos-secret:/opt/kerberos-secret]",

  "k8s.config_map_paths": "[hdfs-conf:/opt/hdfs_conf]"

 }

}
```

**Response Body**

```json
{

 "task_id": "7"

}
```

##### 关于支持HDFS多用户的问题
访问HDFS需要HDFS的配置和认证文件，k8s 容器内也需要相关配置，容器内获取配置需要三步
- 把宿主机的配置文件通过创建 k8s configmap 放到 k8s 中，相关命令 kubectl create configmap。
- 把 configmap 映射到容器的磁盘中使用，相关配置 k8s.secret_paths。
- 算法参数中指定配置文件路径,相关配置 output.hdfs_krb5_conf。
所以只要把不同用户的配置创建成不同的configmap，并映射成容器内的不同文件，就能在请求中指定相应的配置文件和用户名进行认证。

### 5.2.2.Hdfs 输入配置

HDFS 数据输入是基于 hugegraph loader 的格式，点边文件的格式请参见 loader 的操作文档

| **参数**                 | **是否必选** | **说明**                                                     | **默认值** |
| ------------------------ | ------------ | ------------------------------------------------------------ | ---------- |
| input.source_type        | 是           | 输入源类型 (hugegraph/loader) hdfs输入选择loader             | hugegraph  |
| input.loader_struct_path | 是           | loader struct 文件地址, 该文件复用loader struct.json，但需要点、边分开配置 |            |
| input.loader_schema_path | 是           | loader schema 文件地址，结构请参考  http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/schema |            |

**以** **pagerank为例**

```
# 创建 hdfs-config-map

kubectl create configmap hdfs-conf --from-file=./core-site.xml --from-file=./hdfs-site.xml -n hugegraph-computer-system
```

```
# 创建 loader-config

kubectl create configmap loader-config --from-file=./schema.json --from-file=./struct.json -n hugegraph-computer-system
```

```
# 创建 kerberos-secret

kubectl create secret generic kerberos-secret --from-file=/etc/krb5.conf --from-file=/etc/security/keytab/nn.service.keytab -n hugegraph-computer-system
```

**schema.json** **文件示例**

```json
{

   "propertykeys": [

    {

     "id": 1,

     "name": "date",

     "data_type": "DATE",

     "cardinality": "SINGLE",

     "aggregate_type": "NONE",

     "properties": [

     ]

    },

    {

     "id": 2,

     "name": "weight",

     "data_type": "DOUBLE",

     "cardinality": "SINGLE",

     "aggregate_type": "NONE",

     "properties": [

       

     ]

    }

   ],

   "vertexlabels": [

    {

     "id": 1,

     "name": "user",

     "id_strategy": "CUSTOMIZE_NUMBER",

     "primary_keys": [

       

     ],

     "nullable_keys": [

       

     ],

     "index_labels": [

       

     ],

     "properties": [

       

     ]

    }

   ],

   "edgelabels": [

    {

     "id": 1,

     "name": "follow",

     "source_label": "user",

     "target_label": "user",

     "frequency": "SINGLE",

     "sort_keys": [

       

     ],

     "nullable_keys": [

      "weight",

      "date"

     ],

     "index_labels": [

       

     ],

     "properties": [

      "weight",

      "date"

     ]

    }

   ]

  }
```

**struct.json** **文件示例**

```json
{

    "version": "2.0",

    "structs": [

     {

      "id": "1",

      "skip": false,

      "input": {

       "type": "HDFS",

       "path": "hdfs://127.0.0.1/dataset/vertex",

       "core_site_path": "/opt/hdfs_conf/core-site.xml",

       "file_filter": {

        "extensions": [

         "*"

        ]

       },

       "format": "TEXT",

       "delimiter": " ",

       "date_format": "yyyy-MM-dd HH:mm:ss",

       "time_zone": "GMT+8",

       "skipped_line": {

        "regex": "(^#|^//).*|"

       },

       "compression": "NONE",

       "header": [

        "userId"

       ],

       "charset": "UTF-8",

       "list_format": null

      },

      "vertices": [

       {

        "label": "user",

        "skip": false,

        "id": "userId",

        "unfold": false,

        "field_mapping": {

         "userId": "id"

        },

        "value_mapping": {},

        "selected": [

         "userId"

        ],

        "ignored": [],

        "null_values": [

         ""

        ],

        "update_strategies": {}

       }

      ],

      "edges": []

     },

     {

      "id": "2",

      "skip": false,

      "input": {

       "type": "HDFS",

       "path": "hdfs://127.0.0.1:9000/dataset/edge",

       "core_site_path": "/opt/hdfs_conf/core-site.xml",

       "file_filter": {

        "extensions": [

         "*"

        ]

       },

       "format": "TEXT",

       "delimiter": " ",

       "date_format": "yyyy-MM-dd HH:mm:ss",

       "time_zone": "GMT+8",

       "skipped_line": {

        "regex": "(^#|^//).*|"

       },

       "compression": "NONE",

       "header": [

        "source_id",

        "target_id"

       ],

       "charset": "UTF-8",

       "list_format": null

      },

      "vertices": [],

      "edges": [

       {

        "label": "follow",

        "skip": false,

        "source": [

         "source_id"

        ],

        "unfold_source": false,

        "target": [

         "target_id"

        ],

        "unfold_target": false,

        "field_mapping": {

         "source_id": "id",

         "target_id": "id"

        },

        "value_mapping": {},

        "selected": [],

        "ignored": [],

        "null_values": [

         ""

        ],

        "update_strategies": {}

      }

      ]

     }

    ]

   }
```

算法执行示例

```yaml
cat <<EOF | kubectl apply --filename -

apiVersion: hugegraph.baidu.com/v1

kind: HugeGraphComputerJob

metadata:

 namespace: hugegraph-computer-system

 name: &jobId trianglecount-test123 # 任务ID

spec:

 jobId: *jobId

 algorithmName: PageRank # 算法名

 image: xxxxx/xxxxx:latest # 算法镜像地址

 pullPolicy: Always # 是否重新拉取镜像

 workerInstances: 10 # worker 实例数

 secretPaths: # 挂载 secret 到容器目录

  kerberos-secret: /opt/kerberos-secret/

 configMapPaths: # 挂载 configmap 到容器目录

  hdfs-conf: /opt/hdfs_conf/

  loader-config: /opt/dataset/

 computerConf:

  algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类

  job.partitions_count: "20" # 分区数

  input.source_type: "loader"

  input.loader_struct_path: "/opt/dataset/struct.json"

  input.loader_schema_path: "/opt/dataset/schema.json"

  output.output_class: com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput

  output.hdfs_kerberos_enable: "true"

  output.hdfs_path_prefix: /hugegraph-computer/results

  output.hdfs_kerberos_principal: nn/localhost@ESRICHINA.COM

  output.hdfs_krb5_conf: /opt/kerberos-secret/krb5.conf

  output.hdfs_kerberos_keytab: /opt/kerberos-secret/nn.service.keytab

  output.hdfs_core_site_path: /opt/hdfs_conf/core-site.xml

  output.hdfs_site_path: /opt/hdfs_conf/hdfs-site.xml

EOF
```

##### rest-api 示例

**Method & Url**

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

```json
{

"algorithm": "page-rank",

"worker": 5,

"params": {

  "output.output_class":"com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput",

  "input.source_type": "loader",

  "input.loader_struct_path": "/opt/dataset/struct.json",

  "input.loader_schema_path": "/opt/dataset/schema.json",

  "output.hdfs_kerberos_enable": "true",

  "output.hdfs_kerberos_principal": "nn/localhost@ESRICHINA.COM",

  "output.hdfs_krb5_conf": "/opt/kerberos-secret/krb5.conf",

  "output.hdfs_kerberos_keytab": "/opt/kerberos-secret/nn.service.keytab",

  "output.hdfs_core_site_path": "/opt/hdfs_conf/core-site.xml",

  "output.hdfs_site_path": "/opt/hdfs_conf/hdfs-site.xml",

  "k8s.secret_paths": "[kerberos-secret:/opt/kerberos-secret/]",

  "k8s.config_map_paths": "[hdfs-conf:/opt/hdfs_conf/,loader-config:/opt/dataset/]"

  }

}
```



### 5.2.3. docker 中 host 解析问题

如果 hdfs 中使用到域名解析时，需要单独在 docker 中单独指定 hosts 解析域名。

解决方法：建立 k8s configmap，把宿主机的 hosts 文件配置到 k8s 中，再把配置指定到 docker 的 hosts 文件上 

```
# 创建 hosts-config-map, 将 hdfs 解析所用的 hosts 文件追加到 master 机器的 /etc/hosts 中

kubectl create configmap hosts-conf --from-file=/etc/hosts -n hugegraph-computer-system
```

```
# 创建 hdfs-config-map

kubectl create configmap hdfs-conf --from-file=./core-site.xml --from-file=./hdfs-site.xml -n hugegraph-computer-system
```

```
# 创建 kerberos-secret

kubectl create secret generic kerberos-secret --from-file=/etc/krb5.conf --from-file=/etc/security/keytab/nn.service.keytab -n hugegraph-computer-system
```

在 yaml 配置中应用 hosts

```yaml
cat <<EOF | kubectl apply --filename -

apiVersion: hugegraph.baidu.com/v1

kind: HugeGraphComputerJob

metadata:

 namespace: hugegraph-computer-system

 name: &jobId pagerank-test123 # 任务ID

spec:

 jobId: *jobId

 algorithmName: PageRank # 算法名

 image: xxxxx/xxxxx:latest # 算法镜像地址

 pullPolicy: Always # 是否重新拉取镜像

 workerInstances: 10 # worker 实例数

 secretPaths: # 挂载 secret 到容器目录

  kerberos-secret: /opt/kerberos-secret/

 configMapPaths: # 挂载 configmap 到容器目录

  hdfs-conf: /opt/hdfs_conf/

  hosts-conf: /etc #注意：configmap内只有单文件时不会覆盖原有目录下的其他文件，configmap内有多个文件时会覆盖原有目录下的所有文件

 computerConf:

  algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类

  pd.peers: "127.0.0.1:8686"  # pd 地址
  hugegraph.name: "default/hugegraph" # 图空间/图名

  job.partitions_count: "20" # 分区数

  output.output_class: com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput

  output.hdfs_user: hadoop

  output.hdfs_kerberos_enable: "true"

  output.hdfs_path_prefix: /hugegraph-computer/results

  output.hdfs_kerberos_principal: nn/localhost@ESRICHINA.COM

  output.hdfs_krb5_conf: /opt/kerberos-secret/krb5.conf

  output.hdfs_kerberos_keytab: /opt/kerberos-secret/nn.service.keytab

  output.hdfs_core_site_path: /opt/hdfs_conf/core-site.xml

  output.hdfs_site_path: /opt/hdfs_conf/hdfs-site.xml

EOF
```



##### rest-api 示例

**Method & Url**

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

```json
{

 "algorithm": "page-rank",

 "worker": 5,

 "params": {

  "output.output_class": "com.baidu.hugegraph.computer.core.output.hdfs.HdfsOutput",

  "output.hdfs_path_prefix": "/hugegraph-computer/results",

  "output.hdfs_kerberos_enable": "true",

  "output.hdfs_kerberos_principal": "nn/localhost@ESRICHINA.COM",

  "output.hdfs_krb5_conf": "/opt/kerberos-secret/krb5.conf",

  "output.hdfs_kerberos_keytab": "/opt/kerberos-secret/nn.service.keytab",

  "k8s.secret_paths": "[kerberos-secret:/opt/kerberos-secret/]",

  "k8s.config_map_paths": "[hdfs-conf:/opt/hdfs_conf/,hosts-conf:/etc/]"

 }

}
```

 

### 5.2.4.限制每个点的最大边数 (可选)

算法提交时, 可以通过附加 input.limit_edges_in_one_vertex 参数来限制当前算法每个点的最大出边数, 默认值 -1 代表不限制, 需要设置为正整数, 例如

```yaml
cat <<EOF | kubectl apply --filename -

apiVersion: hugegraph.baidu.com/v1

kind: HugeGraphComputerJob

metadata:

 namespace: hugegraph-computer-system

 name: &jobId test-bc # 任务ID

spec:

 jobId: *jobId

 algorithmName: betweenness_centrality # 算法名

 image: xxxxx/xxxxx:latest # 算法镜像地址

 pullPolicy: Always # 是否重新拉取镜像

 workerInstances: 10 # worker 实例数

 computerConf:

  algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams # 算法配置类

  betweenness_centrality.sample_rate: "0.5"
  bsp.max_super_step: "5"
  job.partitions_count: "20" # 分区数
  pd.peers: "127.0.0.1:8686"  # pd 地址
  hugegraph.name: "default/hugegraph" # 图空间/图名
  input.limit_edges_in_one_vertex: "10000" # 限制每个点最大 1万 条边

EOF
```



##### rest-api 示例

**Method & Url**

```
POST http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis
```

**Request Body**

```json
{

 "algorithm": "betweenness-centrality",

 "worker": 5,

 "params": {

    "betweenness_centrality.sample_rate": "0.5",

    "bsp.max_super_step": "5",

    "input.limit_edges_in_one_vertex": "10000"

 }

}
```

**Response Body**

```json
{

 "task_id": "7"

}
```



### 5.2.5.自定义算法输出参数

算法可以自定义输出结果的参数，通过 output.output_property_name 参数来指定算法的输出属性。此参数并不是必须的，每个算法都有默认的输出属性。未设置该属性将使用算法默认输出属性，如果设置了将使用用户设置的输出属性。

```yaml
cat <<EOF | kubectl apply --filename -

apiVersion: hugegraph.baidu.com/v1

kind: HugeGraphComputerJob

metadata:

 namespace: hugegraph-computer-system

 name: &jobId pagerank-beta6 # 任务ID

spec:

 jobId: *jobId

 algorithmName: pagerank # 算法名

 image: xxxxx/xxxxx:latest # 算法镜像地址

 pullPolicy: Always # 是否重新拉取镜像

 workerInstances: 10 # worker 实例数

 computerConf:

  algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类

  job.partitions_count: "20" # 分区数

  pd.peers: "127.0.0.1:8686"  # pd 地址
   
  hugegraph.name: "default/hugegraph" # 图空间/图名

  output.output_property_name: "pagerank_123" # 算法自定义结果输出属性

EOF
```

 

##### rest-api 示例

**Method & Url**

```
POST [http://localhost:8080/graphspaces/{graphspace}/graphs/{hugegraph}/jobs/computerdis](http://localhost:8080/graphs/{hugegraph}/jobs/computerdis)
```

**Request Body**

```json
{

 "algorithm": "page-rank",

 "worker": 5,

 "params": {

  "pagerank.alpha": "0.15",

  "pagerank.l1DiffThreshold": "0.00001",

"bsp.max_super_step": "10",

"output.output_property_name": "pagerank_123"

 }

}
```

**Response Body**

```json
{

 "task_id": "7"

}
```

 

### 5.2.6.worker平均分配的问题

由于k8s pod 分配策略比较复杂，会综合各种因素算分最终确定pod分配，所以在某些环境下，worker全都分配到一台机器上，严重影响性能。目前根据 k8s 版本的不同有两种解决方法：

1) k8s <= 1.15.10

此版本的 k8s 不支持亲和性策略，可以通过限制最大内存的方式达到平均分配的目的。

参数：spec.workerMemory: "20Gi"

此参数略低于 机器实际内存/每台机器的worker数

yaml 示例

```yaml
cat <<EOF | kubectl apply --filename -

apiVersion: hugegraph.baidu.com/v1

kind: HugeGraphComputerJob

metadata:

 namespace: hugegraph-computer-system

 name: &jobId pagerank-test # 任务ID

spec:

 jobId: *jobId

 algorithmName: pagerank  # 算法名

 image: xxxxx/xxxxx:latest # 算法镜像地址

 pullPolicy: Always # 是否重新拉取镜像

 workerInstances: 10 # worker 实例数

 workerMemory: "20Gi" # 最大内存限制

 computerConf:

  algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类

  job.partitions_count: "20" # 分区数

  pd.peers: "127.0.0.1:8686"  # pd 地址
   
  hugegraph.name: "default/hugegraph" # 图空间/图名

EOF
```

rest 示例

```json
{

 "algorithm": "page-rank",

 "worker": 10,

 "params": {

  "pagerank.alpha": "0.15",

  "pagerank.l1DiffThreshold": "0.00001",

"bsp.max_super_step": "10",

"k8s.worker_memory": "20Gi"

 }

}
```

2) k8s > 1.15.10

此版本的 k8s 支持亲和性策略，我们在程序中内置了亲和性策略，默认就可以平均分配。

### 5.2.7.partition并行计算

##### 功能介绍

图计算的每个worker上有多个partition，框架可以指定partition并行计算的线程数，默认值是4。可以通过参数 job.partitions_thread_nums 指定计算线程数。

##### 使用示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId pagerank-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: pagerank # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    job.partitions_count: "20" # 分区数
    job.partitions_thread_nums: "5"
EOF
```

##### rest 示例

```json
{
  "algorithm": "page-rank",
  "worker": 10,
  "params": {
    "pagerank.alpha": "0.15",
    "pagerank.l1DiffThreshold": "0.00001",
    "bsp.max_super_step": "10",
    "job.partitions_thread_nums": "5"
  }
}
```

### 5.2.8.configmap/secret 挂载配置说明

##### configmap配置说明

yaml 参数：configMapPaths

yaml 参数格式：

```yaml
configMapPaths:
 configmap-key1: 挂载目录1
 configmap-key2: 挂载目录2
```

restful 参数：k8s.config_map_paths

restful 参数格式：`[key1:挂载目录1,key2:挂载目录2]`

说明：k8s configmap 到容器目录的映射，挂载的文件名为 configmap 中的 item-key (默认就是原文件名)

注意：如果 configmap 内只有单文件时不会覆盖原有目录下的其他文件，configmap 内有多个文件时会覆盖原有目录下的所有文件

configmap 概念请参考 k8s 官方文档

创建 configmap 的方法请参考 k8s 官方文档

##### secret配置说明

yaml 参数：secretPaths

yaml 参数格式：

```yaml
secretPaths:
 secret-key1: 挂载目录1
 secret-key2: 挂载目录2
```

restful 参数：k8s.secret_paths

restful 参数格式：`[key1:挂载目录1,key2:挂载目录2]`

说明：k8s secret 到容器目录的映射，挂载的文件名为 secret 中的 item-key (默认就是原文件名)

注意：如果 secret 内只有单文件时不会覆盖原有目录下的其他文件，secret 内有多个文件时会覆盖原有目录下的所有文件

secret 概念请参考 k8s 官方文档。

创建 secret 的方法请参考 k8s 官方文档

### 5.2.9.并行导入数据

##### 功能介绍

一个worker中可以通过 input.parallel_num 来指定同时导入数据的线程数，以提高数据导入速度，默认4个。

##### 参数说明

| 名称                   | 是否必填 | 类型    | 默认值  | 取值范围          | 说明                       |
| ---------------------- | -------- | ------- | ------- | ----------------- | -------------------------- |
| input.parallel_num | 否  | Int | 4 | 大于0 | 一个worker并行导入数据的线程数 |


##### 使用示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId pagerank-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: pagerank # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 10 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    job.partitions_count: "20" # 分区数
    input.parallel_num: "5"
EOF
```

##### rest 示例

```json
{
  "algorithm": "page-rank",
  "worker": 10,
  "params": {
    "pagerank.alpha": "0.15",
    "pagerank.l1DiffThreshold": "0.00001",
    "bsp.max_super_step": "10",
    "input.parallel_num": "5"
  }
}
```

### 5.2.10.内存资源限制

##### 参数说明

| 名称                   | 是否必填 | 类型    | 默认值  | 取值范围          | 说明                       |
| ---------------------- | -------- | ------- | ------- | ----------------- | -------------------------- |
| k8s.master_request_memory | 否  | String | - | - | master最小内存，不满足最小内存则分配不成功 |
| k8s.worker_request_memory | 否  | String | - | - | worker最小内存，不满足最小内存则分配不成功 |
| k8s.master_memory | 否  | String | - | - | master最大内存，超过最大内存则会被k8s中止 |
| k8s.worker_memory | 否  | String | - | - | worker最大内存，超过最大内存则会被k8s中止 |

##### 使用示例

```yaml
cat <<EOF | kubectl apply --filename -
apiVersion: hugegraph.baidu.com/v1
kind: HugeGraphComputerJob
metadata:
  namespace: hugegraph-computer-system
  name: &jobId pagerank-beta6 # 任务ID
spec:
  jobId: *jobId
  algorithmName: pagerank # 算法名
  image: xxxxx/xxxxx:latest # 算法镜像地址
  pullPolicy: Always # 是否重新拉取镜像
  workerInstances: 5 # worker 实例数
  computerConf:
    algorithm.params_class: com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams # 算法配置类
    pd.peers: "127.0.0.1:8686"  # pd 地址
    hugegraph.name: "default/hugegraph" # 图空间/图名
    job.partitions_count: "50" # 分区数
    k8s.master_request_memory: "100Mi"
    k8s.worker_request_memory: "5Gi"
    k8s.master_memory: "500Mi"
    k8s.worker_memory: "50Gi"
EOF
```

##### rest 示例

```json
{
  "algorithm": "page-rank",
  "worker": 5,
  "params": {
    "pagerank.alpha": "0.15",
    "pagerank.l1DiffThreshold": "0.00001",
    "bsp.max_super_step": "10",
    "k8s.master_request_memory": "100Mi",
    "k8s.worker_request_memory": "5Gi",
    "k8s.master_memory": "500Mi",
    "k8s.worker_memory": "50Gi",
  }
}
```

## 5.3.参数列表

下表为图计算可设置的参数列表。参数类型为内部类型，rest api 上都需要传字符串。

|      | **参数名称**                            | **参数默认值**                 | **参数类型** | **参数含义**                                                 |
| ---- | --------------------------------------- | ------------------------------ | ------------ | ------------------------------------------------------------ |
| 1    | algorithm.params_class                  | Null.class                     | string       | 算法参数类路径                                               |
| 2    | algorithm.result_class                  | Null.class                     | string       | 算法结果类型                                                 |
| 3    | algorithm.message_class                 | Null.class                     | string       | 算法消息类型                                                 |
| 4    | input.source_type                       | hugegraph                      | string       | 数据加载方式（hugegraph、loader）                            |
| 5    | input.split_fetch_timeout               | 300                            | int          | 拉取数据分片超时时间，单位毫秒                               |
| 6    | input.split_size                        | 1024\*1024                      | int          | 数据分片的字节大小                                           |
| 7    | input.split_max_splits                  | 10000000                       | int          | 最大的分片数                                                 |
| 8    | input.split_page_size                   | 500                            | int          | 一次拉取数据的数量                                           |
| 9    | input.filter_class                      | DefaultInputFilter.class       | string       | 输入点边的过滤条件类，默认过滤掉所有的属性                   |
| 10   | input.edge_direction                    | OUT                            | string       | 点加载边的指向，支持（OUT、IN、BOTH）                        |
| 11   | input.edge_freq                         | MULTIPLE                       | string       | 两点之间边的数量，支持（SINGLE、SINGLE_PER_LABEL、  MULTIPLE） |
| 12   | input.max_edges_in_one_vertex           | 200                            | int          | 数据加载一个点可以存储多少边                                 |
| 13   | input.limit_edges_in_one_vertex         | -1                             | int          | 每个点参数计算的最大边数                                     |
| 14   | input.loader_struct_path                | ""                             | string       | loader方式加载数据生效，loader解析数据文件的配置文件路径     |
| 15   | input.loader_schema_path                | ""                             | string       | loader方式加载数据生效，点边数据schema配置                   |
| 16   | sort.thread_nums                        | 4                              | int          | 发送端排序线程数                                             |
| 17   | output.output_class                     | LogOutput.class                | string       | 算法结果输出类                                               |
| 18   | output.output_property_name             | ""                             | string       | 自定义算法输出参数，默认由算法自己指定                       |
| 19   | output.batch_size                       | 500                            | int          | 算法输出一次输出多少点边                                     |
| 20   | output.batch_threads                    | 1                              | int          | 算法结果批量输出线程池线程数                                 |
| 21   | output.single_threads                   | 1                              | int          | 单条输出的线程池线程数，在批量输出失败时使用                 |
| 22   | output.thread_pool_shutdown_timeout     | 60                             | int          | 输出线程池关闭等待时间，单位是秒                             |
| 23   | output.retry_times                      | 3                              | int          | 输出失败时重试次数                                           |
| 24   | output.retry_interval                   | 10                             | int          | 输出失败重试的时间间隔，单位是秒                             |
| 25   | output.hdfs_url                         | hdfs://127.0.0.1:9000          | string       | 输出为hdfs时生效，hdfs的url                                  |
| 26   | output.hdfs_user                        | hadoop                         | string       | 输出为hdfs时生效，hdfs输出用户                               |
| 27   | output.hdfs_core_site_path              | ""                             | string       | 输出为hdfs时生效，core-site的路径                            |
| 28   | output.hdfs_site_path                   | ""                             | string       | 输出为hdfs时生效，hdfs site的路径                            |
| 29   | output.hdfs_replication                 | 3                              | int          | 输出为hdfs时生效，hdfs输出文件的副本数                       |
| 30   | output.hdfs_path_prefix                 | /hugegraph-computer/results    | stiring      | 输出为hdfs时生效，hdfs输出文件的路径前缀                     |
| 31   | output.hdfs_delimiter                   | ,                              | string       | 输出为hdfs时生效，hdfs文件的分隔符                           |
| 32   | output.hdfs_merge_partitions            | true                           | boolean      | 输出为hdfs时生效，是否合并多个分区的输出文件                 |
| 33   | output.hdfs_kerberos_enable             | false                          | boolean      | 输出为hdfs时生效，是否开启了kerberos                         |
| 34   | output.hdfs_krb5_conf                   | /etc/krb5.conf                 | string       | kerbors配置文件路径                                          |
| 35   | output.hdfs_kerberos_principal          | ""                             | string       | hdfs的kerberos认证主体                                       |
| 36   | output.hdfs_kerberos_keytab             | ""                             | string       | 用于kerberos身份验证的密钥文件                               |
| 37   | job.id                                  | local_0001                     | string       | 算法任务id                                                   |
| 38   | job.workers_count                       | 1                              | int          | 算法任务的worker数量                                         |
| 39   | job.partitions_count                    | 1                              | int          | 算法任务的数据分区数量，要大于worker数量                     |
| 40   | job.partitions_thread_nums              | 4                              | int          | 分区并行计算的线程数                                         |
| 41   | bsp.max_super_step                      | 10                             | int          | 迭代最大轮数                                                 |
| 42   | bsp.etcd_endpoints                      | http://localhost:2379          | string       | etcd的地址                                                   |
| 43   | bsp.register_timeout                    | 5000                           | int          | 等待worker或master注册到etcd的超时时间                       |
| 44   | bsp.wait_workers_timeout                | 24\*60\*60\*1000                  | int          | master等待worker计算结束的超时时间                           |
| 45   | bsp.wait_master_timeout                 | 24\*60\*60\*1000                  | int          | worker等待master计算结束的超时时间                           |
| 46   | bsp.log_interval                        | 30\*1000                        | int          | 等待日志的输出时间间隔                                       |
| 47   | worker.partitioner                      | HashPartitioner.class          | string       | 数据分区类                                                   |
| 48   | worker.computation_class                | Null.class                     | string       | 算法任务类                                                   |
| 49   | worker.combiner_class                   | Null.class                     | string       | 相同数据合并类（消息）                                       |
| 50   | worker.vertex_properties_combiner_class | OverwriteCombiner.class        | string       | 相同点的属性合并类                                           |
| 51   | worker.edge_properties_combiner_class   | OverwriteCombiner.class        | string       | 相同边的属性合并类                                           |
| 52   | worker.received_buffers_bytes_limit     | 100\*1024\*1024                  | long         | 接收端接收数据的buffer大小                                   |
| 53   | worker.wait_sort_timeout                | 10\*60\*1000                     | int          | 排序超时时间                                                 |
| 54   | worker.wait_finish_messages_timeout     | 24\*60\*60\*1000                  | int          | worker等待其他worker完成操作的超时时间                       |
| 55   | worker.data_dirs                        | [jobs]                         | string       | 存储数据文件的目录，可以配置多个                             |
| 56   | worker.write_buffer_threshold           | 50\*1024                        | int          | 发送端buffer大小，单位字节                                   |
| 57   | master.computation_class                | DefaultMasterComputation.class | string       | master节点计算的算法类                                       |
| 58   | hugegraph.url                           | http://127.0.0.1:8080          | string       | hugegraph加载数据的server地址                                |
| 59   | hugegraph.name                          | hugegraph                      | string       | 加载数据的hugegraph server的图名                             |
| 60   | transport.server_host                   | 127.0.0.1                      | string       | 数据传输的监听地址                                           |
| 61   | transport.server_threads                | cpu核心数                      | int          | 接收端的接收线程数量                                         |
| 62   | transport.client_threads                | cpu核心数                      | int          | 发送端的发送线程数量                                         |
| 63   | transport.io_mode                       | AUTO                           | string       | 网络IO模式（AUTO、EPOLL、NIO）                               |
| 64   | transport.client_connect_timeout        | 3000                           | int          | 连接建立超时时间                                             |
| 65   | transport.close_timeout                 | 10000                          | int          | 连接关闭超时时间                                             |
| 66   | transport.sync_request_timeout          | 5000                           | int          | session建立超时时间                                          |
| 67   | transport.finish_session_timeout        | 0                              | int          | session finish等待回复超时时间                               |
| 68   | transport.network_retries               | 3                              | int          | 连接超时重试次数                                             |
| 69   | transport.write_buffer_high_mark        | 64\*1024\*1024                   | int          | netty发送缓冲区大小                                          |
| 70   | transport.write_buffer_low_mark         | 32\*1024\*1024                   | int          | netty发送缓冲区低水位                                        |
| 71   | transport.server_idle_timeout           | 120000                         | int          | 空闲连接关闭超时时间                                         |
| 72   | transport.heartbeat_interval            | 20000                          | int          | 心跳发送时间间隔                                             |
| 73   | transport.max_timeout_heartbeat_count   | 120                            | int          | 发送端未接收到心跳回复的断连阈值                             |
| 74   | hgkv.max_file_size                      | 2\*1024\*1024\*1024               | int          | 数据文件每个segment的最大大小                                |
| 75   | hgkv.max_merge_files                    | 10                             | int          | 单次归并文件数                                               |
| 76   | input.vertex_with_edges_bothdirection   | false                          | boolean      | 加载数据是否是双向边                                         |
| 77   | input.use_id_fixlength                  | false                          | boolean      | 是否使用定长id                                               |
| 78   | input.id_fixlength_bytes                | 8                              | int          | 定长id长度(4、6、8)                                          |
| 79   | hugegraph.token                         | ""                             | string       | hugegraph端的认证信息                                        |
| 80   | hugegraph.usrname                       | ""                             | string       | hugegraph用户名                                              |
| 81   | hugegraph.passwd                        | ""                             | string       | hugegraph用户密码                                            |


## 5.4.算法支持数量级

| 算法名                   | 支持数量级   |     内存开销  |
|:---------------------|:------------|:---------------     |
|    PageRank   |   100亿   |   每个 worker 5G 以下  |
|    Weakly Connected Component   |   100亿   |   每个 worker 5G 以下  |
|    Degree Centrality   |   100亿   |   每个 worker 5G 以下  |
|    Closeness Centrality   |   1亿   |   每个 worker 5G 以下  |
|    Betweenness Centrality   |   1亿   |   每个 worker 5G 以下  |
|    Triangle Count   |   10亿   |   twitter 14亿边，5台机器，每台100G  |
|    Cluster Coefficient   |   10亿   |   twitter 14亿边，5台机器，每台100G  |
|    Rings Detection   |   10万   |   每个 worker 5G 以下  |
|    Filtered Rings Detection   |   1亿   |   每个 worker 5G 以下  |
|    Links   |   1亿   |   每个 worker 5G 以下  |
|    Label Propagation Algorithm   |   100亿   |   每个 worker 5G 以下  |
|    Louvain   |   10亿   |   twitter 14亿边，需要一台120G以上的机器  |
|    Filter SubGraph Matching   |   10亿   |   每个 worker 5G 以下  |
|    K-Core   |   100亿   |   每个 worker 5G 以下  |
|    Personal PageRank   |   100亿   |   每个 worker 5G 以下  |
