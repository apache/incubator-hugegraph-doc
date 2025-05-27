---
title: "HugeGraph-AI Quick Start"
linkTitle: "使用 HugeGraph-AI"
weight: 4
---

### 1 HugeGraph-AI 概述
hugegraph-ai 旨在探索 HugeGraph 与人工智能（AI）的融合，包括与大模型结合的应用，与图机器学习组件的集成等，为开发者在项目中利用 HugeGraph
的 AI 能力提供全面支持。

### 2 环境要求
- python 3.9+  (better to use `3.10`)  
- hugegraph-server 1.3+

### 3 准备工作

1. 启动HugeGraph数据库，可以通过 [Docker](https://hub.docker.com/r/hugegraph/hugegraph)/[Binary Package](https://hugegraph.apache.org/docs/download/download/) 运行它。  
    请参阅详细[文档](https://hugegraph.apache.org/docs/quickstart/hugegraph-server/#31-use-docker-container-convenient-for-testdev)以获取更多指导

2. **Docker部署**  
   如果您希望使用Docker来部署HugeGraph-AI，请按照以下步骤操作：
   - 确保您已安装Docker。
   - 在项目根目录下，使用以下命令拉取远端Docker容器镜像，我们提供了两种容器镜像：
     - **镜像1**：[hugegraph/rag](https://hub.docker.com/r/hugegraph/rag/tags)  
       该镜像用于构建和运行HugeGraph-AI的RAG（检索增强生成）功能，适合需要快速部署和使用的用户。
     - **镜像2**：[hugegraph/rag-bin](https://hub.docker.com/r/hugegraph/rag-bin/tags)  
       该镜像提供了二进制版本的HugeGraph-AI，适合需要更稳定和高效性能的用户。
   - 使用以下命令拉取远端Docker容器镜像：
     ```bash
     docker pull hugegraph/rag:latest # 拉取镜像1
     docker pull hugegraph/rag-bin:latest # 拉取镜像2
     ```
   - 使用以下指令启动Docker容器：
     ```bash
     docker run -it --name rag -p 8001:8001 hugegraph/rag bash
     docker run -it --name rag -p 8001:8001 hugegraph/rag-bin bash
     ```
   - 启动 **Graph RAG** 的 gradio 交互 demo，可以使用以下命令运行：
     ```bash
     python ./src/hugegraph_llm/demo/rag_demo/app.py # 在镜像一创建的容器中启动demo
     ```
     ```bash
     ./app.dist/app.bin # 在镜像二创建的容器中启动demo
     ```
   - 启动后，您可以通过访问 http://localhost:8001 来使用HugeGraph-AI的交互式界面。

3. 克隆项目
    ```bash
    git clone https://github.com/apache/incubator-hugegraph-ai.git
    ```

4. 安装 [hugegraph-python-client](../hugegraph-python-client) 和 [hugegraph_llm](src/hugegraph_llm)
    ```bash
    cd ./incubator-hugegraph-ai # better to use virtualenv (source venv/bin/activate) 
    pip install ./hugegraph-python-client
    pip install -r ./hugegraph-llm/requirements.txt
    ```

5. 进入项目目录
    ```bash
    cd ./hugegraph-llm/src
    ```

6. 启动 **Graph RAG** 的 gradio 交互 demo，可以使用以下命令运行，启动后打开 http://127.0.0.1:8001
    ```bash
    python3 -m hugegraph_llm.demo.rag_demo.app
    ```
    默认主机为 `0.0.0.0` ，端口为 `8001` 。您可以通过传递命令行参数 `--host` 和 `--port` 来更改它们。
    ```bash
    python3 -m hugegraph_llm.demo.rag_demo.app --host 127.0.0.1 --port 18001
    ```

7. 启动 **Text2Gremlin** 的 gradio 交互演示，可以使用以下命令运行，启动后打开 http://127.0.0.1:8002 ，您还可以按上述方式更改默认主机 `0.0.0.0` 和端口 `8002` 。(🚧ing)
    ```bash
    python3 -m hugegraph_llm.demo.gremlin_generate_web_demo
   ```

8. 在运行演示程序后，配置文件文件将被删除。`.env ` 将自动生成在 `hugegraph-llm/.env` 路径下。此外，还有一个与 prompt 相关的配置文件 `config_prompt.yaml` 。也会在`hugegraph-llm/src/hugegraph_llm/resources/demo/config_prompt.yaml`路径下生成。
    您可以在页面上修改内容，触发相应功能后会自动保存到配置文件中。你也可以直接修改文件而无需重启应用程序；只需刷新页面即可加载最新的更改。
    （可选）要重新生成配置文件，您可以将 `config.generate` 与 `-u` 或 `--update` 一起使用。
    ```bash
    python3 -m hugegraph_llm.config.generate --update
    ```

9. （**可选**）您可以使用 [hugegraph-hubble](https://hugegraph.apache.org/docs/quickstart/hugegraph-hubble/#21-use-docker-convenient-for-testdev) 来访问图形数据，可以通过 [Docker/Docker-Compose](https://hub.docker.com/r/hugegraph/hubble) 运行它以获得指导。 （Hubble 是一个图形分析仪表板，包括数据加载/模式管理/图形遍历/显示）。

10. （__可选__）离线下载 NLTK 停用词
    ```bash
    python ./hugegraph_llm/operators/common_op/nltk_helper.py
    ```

## 4 示例 
### 4.1 通过 LLM 在 HugeGraph 中构建知识图谱
#### 4.1.1 通过 gradio 交互式界面构建知识图谱

**参数描述:**  

- Docs:
  - text: 从纯文本建立 rag 索引
  - file: 上传文件：<u>TXT</u> 或 <u>.docx</u>（可同时选择多个文件）
- [Schema](https://hugegraph.apache.org/docs/clients/restful-api/schema/):（接受**2种类型**）
  - 用户定义模式( JSON 格式，遵循[模板](https://github.com/apache/incubator-hugegraph-ai/blob/aff3bbe25fa91c3414947a196131be812c20ef11/hugegraph-llm/src/hugegraph_llm/config/config_data.py#L125)来修改它)
  - 指定 HugeGraph 图实例的名称，它将自动从中获取模式(如 **"hugegraph"**)
- Graph extract head: 用户自定义的图提取提示
- 如果已经存在图数据，你应该点击 "**Rebuild vid Index**" 来更新索引


![gradio-config](/docs/images/gradio-kg.png)

##### 4.1.2 通过代码构建知识图谱

`KgBuilder` 类用于构建知识图谱。下面是使用过程：

1. **初始化**： `KgBuilder` 类使用语言模型的实例进行初始化。这可以从 `LLMs` 类中获得。
   初始化 `LLMs`实例，获取 `LLM`，然后创建一个任务实例 `KgBuilder` 用于图的构建。`KgBuilder` 定义了多个运算符，用户可以根据需要自由组合它们。（提示：`print_result()` 可以在控制台中打印出每一步的结果，而不会影响整个执行逻辑）
   ```python
    from hugegraph_llm.models.llms.init_llm import LLMs
    from hugegraph_llm.operators.kg_construction_task import KgBuilder
    
    TEXT = ""
    builder = KgBuilder(LLMs().get_llm())
    (
        builder
        .import_schema(from_hugegraph="talent_graph").print_result()
        .chunk_split(TEXT).print_result()
        .extract_info(extract_type="property_graph").print_result()
        .commit_to_hugegraph()
        .run()
    )
   ```
   ![gradio-config](/docs/images/kg-uml.png)
2. **导入架构**： `import_schema` 方法用于从源导入架构。源可以是 HugeGraph 实例、用户定义的模式或提取结果。可以链接 `print_result` 方法来打印结果。
    ```python
    # Import schema from a HugeGraph instance
    builder.import_schema(from_hugegraph="xxx").print_result()
    # Import schema from an extraction result
    builder.import_schema(from_extraction="xxx").print_result()
    # Import schema from user-defined schema
    builder.import_schema(from_user_defined="xxx").print_result()
    ```
3. **Chunk Split** ： `chunk_split` 方法用于将输入文本分割为块。文本应该作为字符串参数传递给方法。
    ```python
    # Split the input text into documents
    builder.chunk_split(TEXT, split_type="document").print_result()
    # Split the input text into paragraphs
    builder.chunk_split(TEXT, split_type="paragraph").print_result()
    # Split the input text into sentences
    builder.chunk_split(TEXT, split_type="sentence").print_result()
    ```
4. **信息抽取**：`extract_info` 方法用于从文本中提取信息。文本应该作为字符串参数传递给方法。
    ```python
    TEXT = "Meet Sarah, a 30-year-old attorney, and her roommate, James, whom she's shared a home with since 2010."
    # extract property graph from the input text
    builder.extract_info(extract_type="property_graph").print_result()
    # extract triples from the input text
    builder.extract_info(extract_type="property_graph").print_result()
    ```
5. **Commit to HugeGraph** ： `commit_to_hugegraph` 方法用于将构建的知识图谱提交到 HugeGraph 实例。
    ```python
    builder.commit_to_hugegraph().print_result()
    ```
6. **Run** ： `run` 方法用于执行链式操作。
    ```python
    builder.run()
    ```
    `KgBuilder` 类的方法可以链接在一起以执行一系列操作。

#### 4.2 基于 HugeGraph 的检索增强生成（RAG）

`RAGPipeline` 类用于将 HugeGraph 与大型语言模型集成，以提供检索增强生成功能。下面是使用过程：

1. **提取关键字**：提取关键字并扩展同义词。
    ```python
    from hugegraph_llm.operators.graph_rag_task import RAGPipeline
    graph_rag = RAGPipeline()
    graph_rag.extract_keywords(text="Tell me about Al Pacino.").print_result()
    ```
2. **根据关键字匹配 Vid**:：将节点与图中的关键字匹配。
	```python
    graph_rag.keywords_to_vid().print_result()
   ```
3. **RAG 的查询图**：从 HugeGraph 中检索对应的关键词及其多度关联关系。
     ```python
     graph_rag.query_graphdb(max_deep=2, max_items=30).print_result()
     ```
4. **重新排序搜索结果**：根据问题与结果之间的相似性对搜索结果进行重新排序。
    ```python
    graph_rag.merge_dedup_rerank().print_result()
    ```
5. **合成答案**：总结结果并组织语言来回答问题。
    ```python
    graph_rag.synthesize_answer(vector_only_answer=False, graph_only_answer=True).print_result()
    ```
6. **运行**：`run` 方法用于执行上述操作。
    ```python
    graph_rag.run(verbose=True)
    ```
