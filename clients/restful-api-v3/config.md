## 4.14.其它类

#### 4.14.1.设置服务Rest配置
 
##### 功能介绍

设置服务Rest配置

##### URI

```
PUT graphspaces/${graphspace}/configs/rest
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| properties | 是 | Map  |   |   | 配置信息  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  * |Map| 返回提交的Map信息 |

##### 使用示例

###### Method & Url

```
PUT  http://localhost:8080/graphspaces/gs1/configs/rest
```

###### Request Body

```json
{
    "restserver.url": "http://0.0.0.0:8080",
    "server.start_ignore_single_graph_error": "true",
    "batch.max_write_ratio": "80",
    "batch.max_write_threads": "0",
    "batch.max_vertices_per_batch": "2000",
    "batch.max_edges_per_batch": "2000",
    "server.k8s_url": "https://127.0.0.1:6443",
    "server.k8s_use_ca": true,
    "server.k8s_ca": "/etc/kubernetes/ssl/ca.pem",
    "server.k8s_client_ca": "/etc/kubernetes/ssl/kubernetes.pem",
    "server.k8s_client_key": "/etc/kubernetes/ssl/kubernetes-key8.pem",
    "server.k8s_oltp_image": "xx.xx.xx.xx/kgs_bd/hugegraphserver:3.0.0",
    "k8s.internal_algorithm_image_url": "xx.xx.xx.xx/kgs_bd/hugegraph-computer-algorithm:3.x.x",
    "k8s.internal_algorithm": "[page-rank, degree-centrality, wcc, triangle-count, rings, rings-with-filter, betweenness-centrality, closeness-centrality, lpa, links, kcore, louvain, clustering-coefficient]",
    "k8s.algorithms": "[page-rank:com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams, degree-centrality:com.baidu.hugegraph.computer.algorithm.centrality.degree.DegreeCentralityParams, wcc:com.baidu.hugegraph.computer.algorithm.community.wcc.WccParams, triangle-count:com.baidu.hugegraph.computer.algorithm.community.trianglecount.TriangleCountParams, rings:com.baidu.hugegraph.computer.algorithm.path.rings.RingsDetectionParams, rings-with-filter:com.baidu.hugegraph.computer.algorithm.path.rings.filter.RingsDetectionWithFilterParams, betweenness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams, closeness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.closeness.ClosenessCentralityParams, lpa:com.baidu.hugegraph.computer.algorithm.community.lpa.LpaParams, links:com.baidu.hugegraph.computer.algorithm.path.links.LinksParams, kcore:com.baidu.hugegraph.computer.algorithm.community.kcore.KCoreParams, louvain:com.baidu.hugegraph.computer.algorithm.community.louvain.LouvainParams, clustering-coefficient:com.baidu.hugegraph.computer.algorithm.community.cc.ClusteringCoefficientParams]"
}
```

###### Response Status

```json
200
```

###### Response Body

```json
{
  "restserver.url": "http://0.0.0.0:8080",
  "server.start_ignore_single_graph_error": "true",
  "batch.max_write_ratio": "80",
  "batch.max_write_threads": "0",
  "batch.max_vertices_per_batch": "2000",
  "batch.max_edges_per_batch": "2000",
  "server.k8s_url": "https://127.0.0.1:6443",
  "server.k8s_use_ca": true,
  "server.k8s_ca": "/etc/kubernetes/ssl/ca.pem",
  "server.k8s_client_ca": "/etc/kubernetes/ssl/kubernetes.pem",
  "server.k8s_client_key": "/etc/kubernetes/ssl/kubernetes-key8.pem",
  "server.k8s_oltp_image": "xx.xx.xx.xx/kgs_bd/hugegraphserver:3.0.0",
  "k8s.internal_algorithm_image_url": "xx.xx.xx.xx/kgs_bd/hugegraph-computer-algorithm:3.x.x",
  "k8s.internal_algorithm": "[page-rank, degree-centrality, wcc, triangle-count, rings, rings-with-filter, betweenness-centrality, closeness-centrality, lpa, links, kcore, louvain, clustering-coefficient]",
  "k8s.algorithms": "[page-rank:com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams, degree-centrality:com.baidu.hugegraph.computer.algorithm.centrality.degree.DegreeCentralityParams, wcc:com.baidu.hugegraph.computer.algorithm.community.wcc.WccParams, triangle-count:com.baidu.hugegraph.computer.algorithm.community.trianglecount.TriangleCountParams, rings:com.baidu.hugegraph.computer.algorithm.path.rings.RingsDetectionParams, rings-with-filter:com.baidu.hugegraph.computer.algorithm.path.rings.filter.RingsDetectionWithFilterParams, betweenness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams, closeness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.closeness.ClosenessCentralityParams, lpa:com.baidu.hugegraph.computer.algorithm.community.lpa.LpaParams, links:com.baidu.hugegraph.computer.algorithm.path.links.LinksParams, kcore:com.baidu.hugegraph.computer.algorithm.community.kcore.KCoreParams, louvain:com.baidu.hugegraph.computer.algorithm.community.louvain.LouvainParams, clustering-coefficient:com.baidu.hugegraph.computer.algorithm.community.cc.ClusteringCoefficientParams]"
}
```

#### 4.14.2.查询服务Rest配置

##### 功能介绍

查询服务Rest配置

##### URI

```
GET graphspaces/${graphspace}/configs/rest
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  * |Map| Rest配置信息 |

##### 使用示例

###### Method & Url

```
GET  http://localhost:8080/graphspaces/gs1/configs/rest
```

###### Request Body

无

###### Response Status

```json
200
```

###### Response Body

```json
{
  "restserver.url": "http://0.0.0.0:8080",
  "server.start_ignore_single_graph_error": "true",
  "batch.max_write_ratio": "80",
  "batch.max_write_threads": "0",
  "batch.max_vertices_per_batch": "2000",
  "batch.max_edges_per_batch": "2000",
  "server.k8s_url": "https://127.0.0.1:6443",
  "server.k8s_use_ca": true,
  "server.k8s_ca": "/etc/kubernetes/ssl/ca.pem",
  "server.k8s_client_ca": "/etc/kubernetes/ssl/kubernetes.pem",
  "server.k8s_client_key": "/etc/kubernetes/ssl/kubernetes-key8.pem",
  "server.k8s_oltp_image": "xx.xx.xx.xx/kgs_bd/hugegraphserver:3.0.0",
  "k8s.internal_algorithm_image_url": "xx.xx.xx.xx/kgs_bd/hugegraph-computer-algorithm:3.x.x",
  "k8s.internal_algorithm": "[page-rank, degree-centrality, wcc, triangle-count, rings, rings-with-filter, betweenness-centrality, closeness-centrality, lpa, links, kcore, louvain, clustering-coefficient]",
  "k8s.algorithms": "[page-rank:com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams, degree-centrality:com.baidu.hugegraph.computer.algorithm.centrality.degree.DegreeCentralityParams, wcc:com.baidu.hugegraph.computer.algorithm.community.wcc.WccParams, triangle-count:com.baidu.hugegraph.computer.algorithm.community.trianglecount.TriangleCountParams, rings:com.baidu.hugegraph.computer.algorithm.path.rings.RingsDetectionParams, rings-with-filter:com.baidu.hugegraph.computer.algorithm.path.rings.filter.RingsDetectionWithFilterParams, betweenness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams, closeness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.closeness.ClosenessCentralityParams, lpa:com.baidu.hugegraph.computer.algorithm.community.lpa.LpaParams, links:com.baidu.hugegraph.computer.algorithm.path.links.LinksParams, kcore:com.baidu.hugegraph.computer.algorithm.community.kcore.KCoreParams, louvain:com.baidu.hugegraph.computer.algorithm.community.louvain.LouvainParams, clustering-coefficient:com.baidu.hugegraph.computer.algorithm.community.cc.ClusteringCoefficientParams]"
}
```

#### 4.14.3.删除服务Rest配置

##### 功能介绍

删除服务Rest配置，注意：只能逐条删除

##### URI

```
DELETE graphspaces/${graphspace}/configs/rest/${key}
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |
|  key | 是 | String  |   |   | 配置key值  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  * |Map| Rest配置信息 |

##### 使用示例

###### Method & Url

```
DELETE  http://localhost:8080/graphspaces/gs1/configs/rest/server.start_ignore_single_graph_error
```

###### Request Body

无

###### Response Status

```json
200
```

###### Response Body

```json
{
  "restserver.url": "http://0.0.0.0:8080",
  "batch.max_write_ratio": "80",
  "batch.max_write_threads": "0",
  "batch.max_vertices_per_batch": "2000",
  "batch.max_edges_per_batch": "2000",
  "server.k8s_url": "https://127.0.0.1:6443",
  "server.k8s_use_ca": true,
  "server.k8s_ca": "/etc/kubernetes/ssl/ca.pem",
  "server.k8s_client_ca": "/etc/kubernetes/ssl/kubernetes.pem",
  "server.k8s_client_key": "/etc/kubernetes/ssl/kubernetes-key8.pem",
  "server.k8s_oltp_image": "xx.xx.xx.xx/kgs_bd/hugegraphserver:3.0.0",
  "k8s.internal_algorithm_image_url": "xx.xx.xx.xx/kgs_bd/hugegraph-computer-algorithm:3.x.x",
  "k8s.internal_algorithm": "[page-rank, degree-centrality, wcc, triangle-count, rings, rings-with-filter, betweenness-centrality, closeness-centrality, lpa, links, kcore, louvain, clustering-coefficient]",
  "k8s.algorithms": "[page-rank:com.baidu.hugegraph.computer.algorithm.centrality.pagerank.PageRankParams, degree-centrality:com.baidu.hugegraph.computer.algorithm.centrality.degree.DegreeCentralityParams, wcc:com.baidu.hugegraph.computer.algorithm.community.wcc.WccParams, triangle-count:com.baidu.hugegraph.computer.algorithm.community.trianglecount.TriangleCountParams, rings:com.baidu.hugegraph.computer.algorithm.path.rings.RingsDetectionParams, rings-with-filter:com.baidu.hugegraph.computer.algorithm.path.rings.filter.RingsDetectionWithFilterParams, betweenness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.betweenness.BetweennessCentralityParams, closeness-centrality:com.baidu.hugegraph.computer.algorithm.centrality.closeness.ClosenessCentralityParams, lpa:com.baidu.hugegraph.computer.algorithm.community.lpa.LpaParams, links:com.baidu.hugegraph.computer.algorithm.path.links.LinksParams, kcore:com.baidu.hugegraph.computer.algorithm.community.kcore.KCoreParams, louvain:com.baidu.hugegraph.computer.algorithm.community.louvain.LouvainParams, clustering-coefficient:com.baidu.hugegraph.computer.algorithm.community.cc.ClusteringCoefficientParams]"
}
```

----------------------------------------------------------


#### 4.14.4.设置服务Gremlin配置

##### 功能介绍

设置服务Gremlin配置

##### URI

```
PUT graphspaces/${graphspace}/configs/gremlin
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |

##### Body参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
| yaml | 是 | String  |   |   | 配置信息  |

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  * |String| 返回Gremlin配置信息 |

##### 使用示例

###### Method & Url

```
PUT  http://localhost:8080/graphspaces/gs1/configs/gremlin
```

###### Request Body

```yaml
# host and port of gremlin server, need to be consistent with host and port in rest-server.properties
#host: 127.0.0.1
#port: 8182

# timeout in ms of gremlin query
scriptEvaluationTimeout: 30000

channelizer: org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer

graphs: {}

authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}

scriptEngines: {
  gremlin-groovy: {
    plugins: {
      com.baidu.hugegraph.plugin.HugeGraphGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.server.jsr223.GremlinServerGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.jsr223.ImportGremlinPlugin: {
        classImports: [
            java.lang.Math,
            com.baidu.hugegraph.backend.id.IdGenerator,
            com.baidu.hugegraph.type.define.Directions,
            com.baidu.hugegraph.type.define.NodeRole,
            com.baidu.hugegraph.traversal.algorithm.CollectionPathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.CountTraverser,
            com.baidu.hugegraph.traversal.algorithm.CustomizedCrosspointsTraverser,
            com.baidu.hugegraph.traversal.algorithm.CustomizePathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.FusiformSimilarityTraverser,
            com.baidu.hugegraph.traversal.algorithm.HugeTraverser,
            com.baidu.hugegraph.traversal.algorithm.JaccardSimilarTraverser,
            com.baidu.hugegraph.traversal.algorithm.KneighborTraverser,
            com.baidu.hugegraph.traversal.algorithm.KoutTraverser,
            com.baidu.hugegraph.traversal.algorithm.MultiNodeShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.NeighborRankTraverser,
            com.baidu.hugegraph.traversal.algorithm.PathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.PersonalRankTraverser,
            com.baidu.hugegraph.traversal.algorithm.SameNeighborTraverser,
            com.baidu.hugegraph.traversal.algorithm.ShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.SingleSourceShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.SubGraphTraverser,
            com.baidu.hugegraph.traversal.algorithm.TemplatePathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.steps.EdgeStep,
            com.baidu.hugegraph.traversal.algorithm.steps.RepeatEdgeStep,
            com.baidu.hugegraph.traversal.algorithm.steps.WeightedEdgeStep,
            com.baidu.hugegraph.traversal.optimize.Text,
            com.baidu.hugegraph.traversal.optimize.TraversalUtil,
            com.baidu.hugegraph.util.DateUtil
        ],
        methodImports: [java.lang.Math#*]
      },
      org.apache.tinkerpop.gremlin.jsr223.ScriptFileGremlinPlugin: {
        files: [scripts/empty-sample.groovy]
      }
    }
  }
}
serializers:
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphBinaryMessageSerializerV1,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV1d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV2d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV3d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
metrics: {
  consoleReporter: {enabled: false, interval: 180000},
  csvReporter: {enabled: false, interval: 180000, fileName: ./metrics/gremlin-server-metrics.csv},
  jmxReporter: {enabled: false},
  slf4jReporter: {enabled: false, interval: 180000},
  gangliaReporter: {enabled: false, interval: 180000, addressingMode: MULTICAST},
  graphiteReporter: {enabled: false, interval: 180000}
}
maxInitialLineLength: 4096
maxHeaderSize: 8192
maxChunkSize: 8192
maxContentLength: 65536
maxAccumulationBufferComponents: 1024
resultIterationBatchSize: 64
writeBufferLowWaterMark: 32768
writeBufferHighWaterMark: 65536
ssl: {
  enabled: false
}
```

###### Response Status

```json
200
```

###### Response Body

```yaml
# host and port of gremlin server, need to be consistent with host and port in rest-server.properties
#host: 127.0.0.1
#port: 8182

# timeout in ms of gremlin query
scriptEvaluationTimeout: 30000

channelizer: org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer

graphs: {}

authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}

scriptEngines: {
  gremlin-groovy: {
    plugins: {
      com.baidu.hugegraph.plugin.HugeGraphGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.server.jsr223.GremlinServerGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.jsr223.ImportGremlinPlugin: {
        classImports: [
            java.lang.Math,
            com.baidu.hugegraph.backend.id.IdGenerator,
            com.baidu.hugegraph.type.define.Directions,
            com.baidu.hugegraph.type.define.NodeRole,
            com.baidu.hugegraph.traversal.algorithm.CollectionPathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.CountTraverser,
            com.baidu.hugegraph.traversal.algorithm.CustomizedCrosspointsTraverser,
            com.baidu.hugegraph.traversal.algorithm.CustomizePathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.FusiformSimilarityTraverser,
            com.baidu.hugegraph.traversal.algorithm.HugeTraverser,
            com.baidu.hugegraph.traversal.algorithm.JaccardSimilarTraverser,
            com.baidu.hugegraph.traversal.algorithm.KneighborTraverser,
            com.baidu.hugegraph.traversal.algorithm.KoutTraverser,
            com.baidu.hugegraph.traversal.algorithm.MultiNodeShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.NeighborRankTraverser,
            com.baidu.hugegraph.traversal.algorithm.PathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.PersonalRankTraverser,
            com.baidu.hugegraph.traversal.algorithm.SameNeighborTraverser,
            com.baidu.hugegraph.traversal.algorithm.ShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.SingleSourceShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.SubGraphTraverser,
            com.baidu.hugegraph.traversal.algorithm.TemplatePathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.steps.EdgeStep,
            com.baidu.hugegraph.traversal.algorithm.steps.RepeatEdgeStep,
            com.baidu.hugegraph.traversal.algorithm.steps.WeightedEdgeStep,
            com.baidu.hugegraph.traversal.optimize.Text,
            com.baidu.hugegraph.traversal.optimize.TraversalUtil,
            com.baidu.hugegraph.util.DateUtil
        ],
        methodImports: [java.lang.Math#*]
      },
      org.apache.tinkerpop.gremlin.jsr223.ScriptFileGremlinPlugin: {
        files: [scripts/empty-sample.groovy]
      }
    }
  }
}
serializers:
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphBinaryMessageSerializerV1,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV1d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV2d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV3d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
metrics: {
  consoleReporter: {enabled: false, interval: 180000},
  csvReporter: {enabled: false, interval: 180000, fileName: ./metrics/gremlin-server-metrics.csv},
  jmxReporter: {enabled: false},
  slf4jReporter: {enabled: false, interval: 180000},
  gangliaReporter: {enabled: false, interval: 180000, addressingMode: MULTICAST},
  graphiteReporter: {enabled: false, interval: 180000}
}
maxInitialLineLength: 4096
maxHeaderSize: 8192
maxChunkSize: 8192
maxContentLength: 65536
maxAccumulationBufferComponents: 1024
resultIterationBatchSize: 64
writeBufferLowWaterMark: 32768
writeBufferHighWaterMark: 65536
ssl: {
  enabled: false
}
```

#### 4.14.5.查询服务Gremlin配置

##### 功能介绍

查询服务Gremlin配置

##### URI

```
GET graphspaces/${graphspace}/configs/gremlin
```

##### URI参数

|  名称   | 是否必填  | 类型  | 默认值  | 取值范围  | 说明  |
|  ----  | ----  | ----  | ----  | ----  | ----  |
|  graphspace | 是 | String  |   |   | 图空间  |

##### Body参数

无

##### Response

|  名称   | 类型 |  说明  |
|  ----  | ---|  ----  |
|  * |String| Gremlin配置信息 |

##### 使用示例

###### Method & Url

```
GET  http://localhost:8080/graphspaces/gs1/configs/gremlin
```

###### Request Body

无

###### Response Status

```json
200
```

###### Response Body

```yaml
# host and port of gremlin server, need to be consistent with host and port in rest-server.properties
#host: 127.0.0.1
#port: 8182

# timeout in ms of gremlin query
scriptEvaluationTimeout: 30000

channelizer: org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer

graphs: {}

authentication: {
  authenticator: com.baidu.hugegraph.auth.StandardAuthenticator,
  authenticationHandler: com.baidu.hugegraph.auth.WsAndHttpBasicAuthHandler,
  config: {tokens: conf/rest-server.properties}
}

scriptEngines: {
  gremlin-groovy: {
    plugins: {
      com.baidu.hugegraph.plugin.HugeGraphGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.server.jsr223.GremlinServerGremlinPlugin: {},
      org.apache.tinkerpop.gremlin.jsr223.ImportGremlinPlugin: {
        classImports: [
            java.lang.Math,
            com.baidu.hugegraph.backend.id.IdGenerator,
            com.baidu.hugegraph.type.define.Directions,
            com.baidu.hugegraph.type.define.NodeRole,
            com.baidu.hugegraph.traversal.algorithm.CollectionPathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.CountTraverser,
            com.baidu.hugegraph.traversal.algorithm.CustomizedCrosspointsTraverser,
            com.baidu.hugegraph.traversal.algorithm.CustomizePathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.FusiformSimilarityTraverser,
            com.baidu.hugegraph.traversal.algorithm.HugeTraverser,
            com.baidu.hugegraph.traversal.algorithm.JaccardSimilarTraverser,
            com.baidu.hugegraph.traversal.algorithm.KneighborTraverser,
            com.baidu.hugegraph.traversal.algorithm.KoutTraverser,
            com.baidu.hugegraph.traversal.algorithm.MultiNodeShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.NeighborRankTraverser,
            com.baidu.hugegraph.traversal.algorithm.PathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.PersonalRankTraverser,
            com.baidu.hugegraph.traversal.algorithm.SameNeighborTraverser,
            com.baidu.hugegraph.traversal.algorithm.ShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.SingleSourceShortestPathTraverser,
            com.baidu.hugegraph.traversal.algorithm.SubGraphTraverser,
            com.baidu.hugegraph.traversal.algorithm.TemplatePathsTraverser,
            com.baidu.hugegraph.traversal.algorithm.steps.EdgeStep,
            com.baidu.hugegraph.traversal.algorithm.steps.RepeatEdgeStep,
            com.baidu.hugegraph.traversal.algorithm.steps.WeightedEdgeStep,
            com.baidu.hugegraph.traversal.optimize.Text,
            com.baidu.hugegraph.traversal.optimize.TraversalUtil,
            com.baidu.hugegraph.util.DateUtil
        ],
        methodImports: [java.lang.Math#*]
      },
      org.apache.tinkerpop.gremlin.jsr223.ScriptFileGremlinPlugin: {
        files: [scripts/empty-sample.groovy]
      }
    }
  }
}
serializers:
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphBinaryMessageSerializerV1,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV1d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV2d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
  - { className: org.apache.tinkerpop.gremlin.driver.ser.GraphSONMessageSerializerV3d0,
      config: {
        serializeResultToString: false,
        ioRegistries: [com.baidu.hugegraph.io.HugeGraphIoRegistry]
      }
  }
metrics: {
  consoleReporter: {enabled: false, interval: 180000},
  csvReporter: {enabled: false, interval: 180000, fileName: ./metrics/gremlin-server-metrics.csv},
  jmxReporter: {enabled: false},
  slf4jReporter: {enabled: false, interval: 180000},
  gangliaReporter: {enabled: false, interval: 180000, addressingMode: MULTICAST},
  graphiteReporter: {enabled: false, interval: 180000}
}
maxInitialLineLength: 4096
maxHeaderSize: 8192
maxChunkSize: 8192
maxContentLength: 65536
maxAccumulationBufferComponents: 1024
resultIterationBatchSize: 64
writeBufferLowWaterMark: 32768
writeBufferHighWaterMark: 65536
ssl: {
  enabled: false
}
```
