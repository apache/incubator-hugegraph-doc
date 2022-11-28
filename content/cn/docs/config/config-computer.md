---
title: "HugeGraph-Computer 配置"
linkTitle: "Config Computer"
weight: 5
---

### Computer Config Options

| config option |  default value    | description |
| ---- | ---- | ---- |
|algorithm.message_class|org.apache.hugegraph.computer.core.config.Null|The class of message passed when compute vertex.|
|algorithm.params_class|org.apache.hugegraph.computer.core.config.Null|The class used to transfer algorithms' parameters before algorithm been run.|
|algorithm.result_class|org.apache.hugegraph.computer.core.config.Null|The class of vertex's value, the instance is used to store computation result for the vertex.|
|allocator.max_vertices_per_thread|10000|Maximum number of vertices per thread processed in each memory allocator|
|bsp.etcd_endpoints|http://localhost:2379|The end points to access etcd.|
|bsp.log_interval|30000|The log interval(in ms) to print the log while waiting bsp event.|
|bsp.max_super_step|10|The max super step of the algorithm.|
|bsp.register_timeout|300000|The max timeout to wait for master and works to register.|
|bsp.wait_master_timeout|86400000|The max timeout(in ms) to wait for master bsp event.|
|bsp.wait_workers_timeout|86400000|The max timeout to wait for workers bsp event.|
|hgkv.max_data_block_size|65536|The max byte size of hgkv-file data block.|
|hgkv.max_file_size|2147483648|The max number of bytes in each hgkv-file.|
|hgkv.max_merge_files|10|The max number of files to merge at one time.|
|hgkv.temp_file_dir|/tmp/hgkv|This folder is used to store temporary files, temporary files will be generated during the file merging process.|
|hugegraph.name|hugegraph|The graph name to load data and write results back.|
|hugegraph.url|http://127.0.0.1:8080|The hugegraph url to load data and write results back.|
|input.edge_direction|OUT|The data of the edge in which direction is loaded, when the value is BOTH, the edges in both OUT and IN direction will be loaded.|
|input.edge_freq|MULTIPLE|The frequency of edges can exist between a pair of vertices, allowed values: [SINGLE, SINGLE_PER_LABEL, MULTIPLE]. SINGLE means that only one edge can exist between a pair of vertices, use sourceId + targetId to identify it; SINGLE_PER_LABEL means that each edge label can exist one edge between a pair of vertices, use sourceId + edgelabel + targetId to identify it; MULTIPLE means that many edge can exist between a pair of vertices, use sourceId + edgelabel + sortValues + targetId to identify it.|
|input.filter_class|org.apache.hugegraph.computer.core.input.filter.DefaultInputFilter|The class to create input-filter object, input-filter is used to Filter vertex edges according to user needs.|
|input.loader_schema_path||The schema path of loader input, only takes effect when the input.source_type=loader is enabled|
|input.loader_struct_path||The struct path of loader input, only takes effect when the input.source_type=loader is enabled|
|input.max_edges_in_one_vertex|200|The maximum number of adjacent edges allowed to be attached to a vertex, the adjacent edges will be stored and transferred together as a batch unit.|
|input.source_type|hugegraph-server|The source type to load input data, allowed values: ['hugegraph-server', 'hugegraph-loader'], the 'hugegraph-loader' means use hugegraph-loader load data from HDFS or file, if use 'hugegraph-loader' load data then please config 'input.loader_struct_path' and 'input.loader_schema_path'.|
|input.split_fetch_timeout|300|The timeout in seconds to fetch input splits|
|input.split_max_splits|10000000|The maximum number of input splits|
|input.split_page_size|500|The page size for streamed load input split data|
|input.split_size|1048576|The input split size in bytes|
|job.id|local_0001|The job id on Yarn cluster or K8s cluster.|
|job.partitions_count|1|The partitions count for computing one graph algorithm job.|
|job.partitions_thread_nums|4|The number of threads for partition parallel compute.|
|job.workers_count|1|The workers count for computing one graph algorithm job.|
|master.computation_class|org.apache.hugegraph.computer.core.master.DefaultMasterComputation|Master-computation is computation that can determine whether to continue next superstep. It runs at the end of each superstep on master.|
|output.batch_size|500|The batch size of output|
|output.batch_threads|1|The threads number used to batch output|
|output.hdfs_core_site_path||The hdfs core site path.|
|output.hdfs_delimiter|,|The delimiter of hdfs output.|
|output.hdfs_kerberos_enable|false|Is Kerberos authentication enabled for Hdfs.|
|output.hdfs_kerberos_keytab||The Hdfs's key tab file for kerberos authentication.|
|output.hdfs_kerberos_principal||The Hdfs's principal for kerberos authentication.|
|output.hdfs_krb5_conf|/etc/krb5.conf|Kerberos configuration file.|
|output.hdfs_merge_partitions|true|Whether merge output files of multiple partitions.|
|output.hdfs_path_prefix|/hugegraph-computer/results|The directory of hdfs output result.|
|output.hdfs_replication|3|The replication number of hdfs.|
|output.hdfs_site_path||The hdfs site path.|
|output.hdfs_url|hdfs://127.0.0.1:9000|The hdfs url of output.|
|output.hdfs_user|hadoop|The hdfs user of output.|
|output.output_class|org.apache.hugegraph.computer.core.output.LogOutput|The class to output the computation result of each vertex. Be called after iteration computation.|
|output.result_name|value|The value is assigned dynamically by #name() of instance created by WORKER_COMPUTATION_CLASS.|
|output.result_write_type|OLAP_COMMON|The result write-type to output to hugegraph, allowed values are: [OLAP_COMMON, OLAP_SECONDARY, OLAP_RANGE].|
|output.retry_interval|10|The retry interval when output failed|
|output.retry_times|3|The retry times when output failed|
|output.single_threads|1|The threads number used to single output|
|output.thread_pool_shutdown_timeout|60|The timeout seconds of output threads pool shutdown|
|output.with_adjacent_edges|false|Output the adjacent edges of the vertex or not|
|output.with_edge_properties|false|Output the properties of the edge or not|
|output.with_vertex_properties|false|Output the properties of the vertex or not|
|sort.thread_nums|4|The number of threads performing internal sorting.|
|transport.client_connect_timeout|3000|The timeout(in ms) of client connect to server.|
|transport.client_threads|4|The number of transport threads for client.|
|transport.close_timeout|10000|The timeout(in ms) of close server or close client.|
|transport.finish_session_timeout|0|The timeout(in ms) to finish session, 0 means using (transport.sync_request_timeout * transport.max_pending_requests).|
|transport.heartbeat_interval|20000|The minimum interval(in ms) between heartbeats on client side.|
|transport.io_mode|AUTO|The network IO Mode, either 'NIO', 'EPOLL', 'AUTO', the 'AUTO' means selecting the property mode automatically.|
|transport.max_pending_requests|8|The max number of client unreceived ack, it will trigger the sending unavailable if the number of unreceived ack >= max_pending_requests.|
|transport.max_syn_backlog|511|The capacity of SYN queue on server side, 0 means using system default value.|
|transport.max_timeout_heartbeat_count|120|The maximum times of timeout heartbeat on client side, if the number of timeouts waiting for heartbeat response continuously > max_heartbeat_timeouts the channel will be closed from client side.|
|transport.min_ack_interval|200|The minimum interval(in ms) of server reply ack.|
|transport.min_pending_requests|6|The minimum number of client unreceived ack, it will trigger the sending available if the number of unreceived ack < min_pending_requests.|
|transport.network_retries|3|The number of retry attempts for network communication,if network unstable.|
|transport.provider_class|org.apache.hugegraph.computer.core.network.netty.NettyTransportProvider|The transport provider, currently only supports Netty.|
|transport.receive_buffer_size|0|The size of socket receive-buffer in bytes, 0 means using system default value.|
|transport.recv_file_mode|true|Whether enable receive buffer-file mode, it will receive buffer write file from socket by zero-copy if enable.|
|transport.send_buffer_size|0|The size of socket send-buffer in bytes, 0 means using system default value.|
|transport.server_host|127.0.0.1|The server hostname or ip to listen on to transfer data.|
|transport.server_idle_timeout|360000|The max timeout(in ms) of server idle.|
|transport.server_port|0|The server port to listen on to transfer data. The system will assign a random port if it's set to 0.|
|transport.server_threads|4|The number of transport threads for server.|
|transport.sync_request_timeout|10000|The timeout(in ms) to wait response after sending sync-request.|
|transport.tcp_keep_alive|true|Whether enable TCP keep-alive.|
|transport.transport_epoll_lt|false|Whether enable EPOLL level-trigger.|
|transport.write_buffer_high_mark|67108864|The high water mark for write buffer in bytes, it will trigger the sending unavailable if the number of queued bytes > write_buffer_high_mark.|
|transport.write_buffer_low_mark|33554432|The low water mark for write buffer in bytes, it will trigger the sending available if the number of queued bytes < write_buffer_low_mark.org.apache.hugegraph.config.OptionChecker$$Lambda$97/0x00000008001c8440@776a6d9b|
|transport.write_socket_timeout|3000|The timeout(in ms) to write data to socket buffer.|
|valuefile.max_segment_size|1073741824|The max number of bytes in each segment of value-file.|
|worker.combiner_class|org.apache.hugegraph.computer.core.config.Null|Combiner can combine messages into one value for a vertex, for example page-rank algorithm can combine messages of a vertex to a sum value.|
|worker.computation_class|org.apache.hugegraph.computer.core.config.Null|The class to create worker-computation object, worker-computation is used to compute each vertex in each superstep.|
|worker.data_dirs|[jobs]|The directories separated by ',' that received vertices and messages can persist into.|
|worker.edge_properties_combiner_class|org.apache.hugegraph.computer.core.combiner.OverwritePropertiesCombiner|The combiner can combine several properties of the same edge into one properties at inputstep.|
|worker.partitioner|org.apache.hugegraph.computer.core.graph.partition.HashPartitioner|The partitioner that decides which partition a vertex should be in, and which worker a partition should be in.|
|worker.received_buffers_bytes_limit|104857600|The limit bytes of buffers of received data, the total size of all buffers can't excess this limit. If received buffers reach this limit, they will be merged into a file.|
|worker.vertex_properties_combiner_class|org.apache.hugegraph.computer.core.combiner.OverwritePropertiesCombiner|The combiner can combine several properties of the same vertex into one properties at inputstep.|
|worker.wait_finish_messages_timeout|86400000|The max timeout(in ms) message-handler wait for finish-message of all workers.|
|worker.wait_sort_timeout|600000|The max timeout(in ms) message-handler wait for sort-thread to sort one batch of buffers.|
|worker.write_buffer_capacity|52428800|The initial size of write buffer that used to store vertex or message.|
|worker.write_buffer_threshold|52428800|The threshold of write buffer, exceeding it will trigger sorting, the write buffer is used to store vertex or message.|

### K8s Operator Config Options

> NOTE: Option needs to be converted through environment variable settings, e.g k8s.internal_etcd_url => INTERNAL_ETCD_URL

| config option |  default value    | description |
| ---- | ---- | ---- |
|k8s.auto_destroy_pod|true|Whether to automatically destroy all pods when the job is completed or failed.|
|k8s.close_reconciler_timeout|120|The max timeout(in ms) to close reconciler.|
|k8s.internal_etcd_url|http://127.0.0.1:2379|The internal etcd url for operator system.|
|k8s.max_reconcile_retry|3|The max retry times of reconcile.|
|k8s.probe_backlog|50|The maximum backlog for serving health probes.|
|k8s.probe_port|9892|The value is the port that the controller bind to for serving health probes.|
|k8s.ready_check_internal|1000|The time interval(ms) of check ready.|
|k8s.ready_timeout|30000|The max timeout(in ms) of check ready.|
|k8s.reconciler_count|10|The max number of reconciler thread.|
|k8s.resync_period|600000|The minimum frequency at which watched resources are reconciled.|
|k8s.timezone|Asia/Shanghai|The timezone of computer job and operator.|
|k8s.watch_namespace|hugegraph-computer-system|The value is watch custom resources in the namespace, ignore other namespaces, the '*' means is all namespaces will be watched.|

### HugeGraph-Computer CRD

> CRD: https://github.com/apache/hugegraph-computer/blob/master/computer-k8s-operator/manifest/hugegraph-computer-crd.v1.yaml

| spec            | default value           | description                                                  | required |
| --------------- | ----------------------- | ------------------------------------------------------------ | -------- |
| algorithmName   |                         | The name of algorithm.                                       | true     |
| jobId           |                         | The job id.                                                  | true     |
| image           |                         | The image of algorithm.                                      | true     |
| computerConf    |                         | The map of computer config options.                          | true     |
| workerInstances |                         | The number of worker instances, it will instead the 'job.workers_count' option. | true     |
| pullPolicy      | Always                  | The pull-policy of image, detail please refer to: https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy | false    |
| pullSecrets     |                         | The pull-secrets of Image, detail please refer to: https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod | false    |
| masterCpu       |                         | The cpu limit of master, the unit can be 'm' or without unit detail please refer to：[https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) | false    |
| workerCpu       |                         | The cpu limit of worker, the unit can be 'm' or without unit detail please refer to：[https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-cpu) | false    |
| masterMemory    |                         | The memory limit of master, the unit can be one of Ei、Pi、Ti、Gi、Mi、Ki detail please refer to：[https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) | false    |
| workerMemory    |                         | The memory limit of worker, the unit can be one of Ei、Pi、Ti、Gi、Mi、Ki detail please refer to：[https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#meaning-of-memory) | false    |
| log4jXml        |                         | The content of log4j.xml for computer job.                   | false    |
| jarFile         |                         | The jar path of computer algorithm.                          | false    |
| remoteJarUri    |                         | The remote jar uri of computer algorithm, it will overlay algorithm image. | false    |
| jvmOptions      |                         | The java startup parameters of computer job.                 | false    |
| envVars         |                         | please refer to: https://kubernetes.io/docs/tasks/inject-data-application/define-interdependent-environment-variables/ | false    |
| envFrom         |                         | please refer to: https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/ | false    |
| masterCommand   | bin/start-computer.sh   | The run command of master, equivalent to 'Entrypoint' field of Docker. | false    |
| masterArgs      | ["-r master", "-d k8s"] | The run args of master, equivalent to 'Cmd' field of Docker. | false    |
| workerCommand   | bin/start-computer.sh   | The run command of worker, equivalent to 'Entrypoint' field of Docker. | false    |
| workerArgs      | ["-r worker", "-d k8s"] | The run args of worker, equivalent to 'Cmd' field of Docker. | false    |
| volumes         |                         | Please refer to: https://kubernetes.io/docs/concepts/storage/volumes/ | false    |
| volumeMounts    |                         | Please refer to: https://kubernetes.io/docs/concepts/storage/volumes/ | false    |
| secretPaths     |                         | The map of k8s-secret name and mount path.                   | false    |
| configMapPaths  |                         | The map of k8s-configmap name and mount path.                | false    |
| podTemplateSpec |                         | Please refer to: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec | false    |
| securityContext |                         | Please refer to: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ | false    |

### KubeDriver Config Options

| config option |  default value    | description |
| ---- | ---- | ---- |
|k8s.build_image_bash_path||The path of command used to build image.|
|k8s.enable_internal_algorithm|true|Whether enable internal algorithm.|
|k8s.framework_image_url|hugegraph/hugegraph-computer:latest|The image url of computer framework.|
|k8s.image_repository_password||The password for login image repository.|
|k8s.image_repository_registry||The address for login image repository.|
|k8s.image_repository_url|hugegraph/hugegraph-computer|The url of image repository.|
|k8s.image_repository_username||The username for login image repository.|
|k8s.internal_algorithm|[pageRank]|The name list of all internal algorithm.|
|k8s.internal_algorithm_image_url|hugegraph/hugegraph-computer:latest|The image url of internal algorithm.|
|k8s.jar_file_dir|/cache/jars/|The directory where the algorithm jar to upload location.|
|k8s.kube_config|~/.kube/config|The path of k8s config file.|
|k8s.log4j_xml_path||The log4j.xml path for computer job.|
|k8s.namespace|hugegraph-computer-system|The namespace of hugegraph-computer system.|
|k8s.pull_secret_names|[]|The names of pull-secret for pulling image.|
