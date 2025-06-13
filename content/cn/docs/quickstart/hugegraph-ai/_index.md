---
title: "HugeGraph-AI"
linkTitle: "HugeGraph-AI"
weight: 3
---

> 请参阅 AI 仓库的 [README](https://github.com/apache/incubator-hugegraph-ai/tree/main/hugegraph-llm#readme) 以获取最新的文档，官网会**定期**更新同步。

> AI 总结项目文档：[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/apache/incubator-hugegraph-ai)

## 1. 摘要

`hugegraph-llm` 是一个用于实现和研究大语言模型相关功能的工具。
该项目包含可运行的演示（demo），也可以作为第三方库使用。

众所周知，图系统可以帮助大模型解决时效性和幻觉等挑战，
而大模型则可以帮助图系统解决成本相关的问题。

通过这个项目，我们旨在降低图系统的使用成本，并减少构建知识图谱的复杂性。
本项目将为图系统和大语言模型提供更多的应用和集成解决方案。
1.  通过 LLM + HugeGraph 构建知识图谱
2.  使用自然语言操作图数据库 (Gremlin/Cypher)
3.  知识图谱补充答案上下文 (GraphRAG → Graph Agent)

## 2. 环境要求
> [!IMPORTANT]
> - python 3.10+ (未在 3.12 中测试)
> - hugegraph-server 1.3+ (建议使用 1.5+)
> - uv 0.7+

## 3. 准备工作

### 3.1 Docker

**Docker 部署**  
   您也可以使用 Docker 来部署 HugeGraph-AI：
   - 确保您已安装 Docker
   - 我们提供两个容器镜像：
     - **镜像 1**: [hugegraph/rag](https://hub.docker.com/r/hugegraph/rag/tags)  
       用于构建和运行 RAG 功能，适合快速部署和开发
     - **镜像 2**: [hugegraph/rag-bin](https://hub.docker.com/r/hugegraph/rag-bin/tags)  
       使用 Nuitka 编译的二进制版本，在生产环境中性能更稳定、更高效
   - 拉取 Docker 镜像：
     ```bash
     docker pull hugegraph/rag:latest # 拉取镜像1
     docker pull hugegraph/rag-bin:latest # 拉取镜像2
     ```
   - 启动 Docker 容器：
     ```bash
     docker run -it --name rag -v /path/to/.env:/home/work/hugegraph-llm/.env -p 8001:8001 hugegraph/rag bash
     docker run -it --name rag-bin -v /path/to/.env:/home/work/hugegraph-llm/.env -p 8001:8001 hugegraph/rag-bin bash
     ```
   - 启动 Graph RAG 演示：
     ```bash
     # 针对镜像 1
     python ./src/hugegraph_llm/demo/rag_demo/app.py # 或运行 python -m hugegraph_llm.demo.rag_demo.app

     # 针对镜像 2
     ./app.dist/app.bin
     ```
   - 访问接口 http://localhost:8001

### 3.2 从源码构建

1. 启动 HugeGraph 数据库，您可以通过 [Docker](https://hub.docker.com/r/hugegraph/hugegraph)/[二进制包](https://hugegraph.apache.org/docs/download/download/) 运行它。
    有一个使用 docker 的简单方法：  
    ```bash
   docker run -itd --name=server -p 8080:8080 hugegraph/hugegraph
    ```  
   更多指引请参阅详细文档 [doc](/docs/quickstart/hugegraph/hugegraph-server/#31-use-docker-container-convenient-for-testdev)。

2. 配置 uv 环境，使用官方安装器安装 uv，其他安装方法请参见 [uv 文档](https://docs.astral.sh/uv/configuration/installer/)。
    ```bash
    # 如果遇到网络问题，可以尝试使用 pipx 或 pip 安装 uv，详情请参阅 uv 文档
    curl -LsSf [https://astral.sh/uv/install.sh](https://astral.sh/uv/install.sh) | sh  - # 安装最新版本，如 0.7.3+
    ```

3. 克隆本项目
    ```bash
    git clone [https://github.com/apache/incubator-hugegraph-ai.git](https://github.com/apache/incubator-hugegraph-ai.git)
    ```
4. 配置依赖环境
    ```bash
    cd incubator-hugegraph-ai/hugegraph-llm
    uv venv && source .venv/bin/activate
    uv pip install -e .
    ```  
    如果由于网络问题导致依赖下载失败或过慢，建议修改 `hugegraph-llm/pyproject.toml`。

5. 启动 **Graph RAG** 的 Gradio 交互式演示，运行以下命令，然后在浏览器中打开 http://127.0.0.1:8001。
    ```bash
    python -m hugegraph_llm.demo.rag_demo.app  # 等同于 "uv run xxx"
    ```
    默认主机是 `0.0.0.0`，端口是 `8001`。您可以通过传递命令行参数 `--host` 和 `--port` 来更改它们。  
    ```bash
    python -m hugegraph_llm.demo.rag_demo.app --host 127.0.0.1 --port 18001
    ```
   
6. 运行 Web 演示后，将在路径 `hugegraph-llm/.env` 下自动生成配置文件 `.env`。此外，还将在路径 `hugegraph-llm/src/hugegraph_llm/resources/demo/config_prompt.yaml` 下生成一个与提示（prompt）相关的配置文件 `config_prompt.yaml`。
    您可以在网页上修改内容，触发相应功能后，更改将自动保存到配置文件中。您也可以直接修改文件而无需重启 Web 应用；刷新页面即可加载您的最新更改。
    (可选) 要重新生成配置文件，您可以使用 `config.generate` 并加上 `-u` 或 `--update` 参数。  
    ```bash
    python -m hugegraph_llm.config.generate --update
    ```
    注意：`Litellm` 支持多个 LLM 提供商，请参阅 [litellm.ai](https://docs.litellm.ai/docs/providers) 进行配置。
7. (__可选__) 您可以使用 
    [hugegraph-hubble](/docs/quickstart/toolchain/hugegraph-hubble/#21-use-docker-convenient-for-testdev) 
    来访问图数据，可以通过 [Docker/Docker-Compose](https://hub.docker.com/r/hugegraph/hubble) 
    运行它以获取指导。(Hubble 是一个图分析仪表盘，包括数据加载/Schema管理/图遍历/展示功能)。
8. (__可选__) 离线下载 NLTK 停用词  
    ```bash
    python ./hugegraph_llm/operators/common_op/nltk_helper.py
    ```
> [!TIP]   
> 您也可以参考我们的[快速入门](https://github.com/apache/incubator-hugegraph-ai/blob/main/hugegraph-llm/quick_start.md)文档来了解如何使用它以及基本的查询逻辑 🚧

## 4. 示例

### 4.1 通过 LLM 在 HugeGraph 中构建知识图谱

#### 4.1.1 通过 Gradio 交互界面构建知识图谱

**参数说明：**  

- Docs（文档）:
  - text: 从纯文本构建 RAG 索引
  - file: 上传文件，文件应为 <u>.txt</u> 或 <u>.docx</u> (可同时选择多个文件)
- [Schema](https://hugegraph.apache.org/docs/clients/restful-api/schema/) (模式): (除**两种类型**外)
  - 用户自定义 Schema (JSON 格式, 遵循此[模板](https://github.com/apache/incubator-hugegraph-ai/blob/aff3bbe25fa91c3414947a196131be812c20ef11/hugegraph-llm/src/hugegraph_llm/config/config_data.py#L125)进行修改)
  - 指定 HugeGraph 图实例的名称，它将自动从中获取 Schema (例如 **"hugegraph"**)
- Graph extract head (图谱抽取提示头): 用户自定义的图谱抽取提示
- 如果已存在图数据，您应点击 "**Rebuild vid Index**" (重建顶点ID索引) 来更新索引

![gradio-配置](https://hugegraph.apache.org/docs/images/gradio-kg.png)

#### 4.1.2 通过代码构建知识图谱

`KgBuilder` 类用于构建知识图谱。以下是简要使用指南：

1. **初始化**: `KgBuilder` 类使用一个语言模型的实例进行初始化。该实例可以从 `LLMs` 类中获取。
    初始化 LLMs 实例，获取 LLM，然后为图谱构建创建一个任务实例 `KgBuilder`。`KgBuilder` 定义了多个算子，用户可以根据需要自由组合它们。(提示: `print_result()` 可以在控制台中打印每一步的结果，而不影响整体执行逻辑)

    ```python
    from hugegraph_llm.models.llms.init_llm import LLMs
    from hugegraph_llm.operators.kg_construction_task import KgBuilder
    
    TEXT = ""
    builder = KgBuilder(LLMs().get_chat_llm())
    (
        builder
        .import_schema(from_hugegraph="talent_graph").print_result()
        .chunk_split(TEXT).print_result()
        .extract_info(extract_type="property_graph").print_result()
        .commit_to_hugegraph()
        .run()
    )
    ```
    ![gradio-配置-uml](https://hugegraph.apache.org/docs/images/kg-uml.png)
2. **导入 Schema**: `import_schema` 方法用于从一个来源导入 Schema。来源可以是一个 HugeGraph 实例、一个用户定义的 Schema 或一个抽取结果。可以链接 `print_result` 方法来打印结果。
    ```python
    # 从 HugeGraph 实例导入 Schema
    builder.import_schema(from_hugegraph="xxx").print_result()
    # 从抽取结果导入 Schema
    builder.import_schema(from_extraction="xxx").print_result()
    # 从用户定义的 Schema 导入
    builder.import_schema(from_user_defined="xxx").print_result()
    ```
3. **分块切分**: `chunk_split` 方法用于将输入文本切分成块。文本应作为字符串参数传递给该方法。
    ```python
    # 将输入文本切分成文档
    builder.chunk_split(TEXT, split_type="document").print_result()
    # 将输入文本切分成段落
    builder.chunk_split(TEXT, split_type="paragraph").print_result()
    # 将输入文本切分成句子
    builder.chunk_split(TEXT, split_type="sentence").print_result()
    ```
4. **提取信息**: `extract_info` 方法用于从文本中提取信息。文本应作为字符串参数传递给该方法。
    ```python
    TEXT = "Meet Sarah, a 30-year-old attorney, and her roommate, James, whom she's shared a home with since 2010."
    # 从输入文本中提取属性图
    builder.extract_info(extract_type="property_graph").print_result()
    # 从输入文本中提取三元组
    builder.extract_info(extract_type="property_graph").print_result()
    ```
5. **提交到 HugeGraph**: `commit_to_hugegraph` 方法用于将构建的知识图谱提交到一个 HugeGraph 实例。
    ```python
    builder.commit_to_hugegraph().print_result()
    ```
6. **运行**: `run` 方法用于执行链式操作。
    ```python
    builder.run()
    ```
    `KgBuilder` 类的方法可以链接在一起以执行一系列操作。

### 4.2 基于 HugeGraph 的检索增强生成 (RAG)

`RAGPipeline` 类用于将 HugeGraph 与大语言模型集成，以提供检索增强生成的能力。
以下是简要使用指南：

1. **提取关键词**: 提取关键词并扩展同义词。
    ```python
    from hugegraph_llm.operators.graph_rag_task import RAGPipeline
    graph_rag = RAGPipeline()
    graph_rag.extract_keywords(text="告诉我关于 Al Pacino 的事情。").print_result()
    ```
2. **从关键词匹配顶点ID**: 在图中用关键词匹配节点。
    ```python
    graph_rag.keywords_to_vid().print_result()
    ```
3. **查询图以进行 RAG**: 从 HugeGraph 中检索相应的关键词及其多跳关联关系。
     ```python
     graph_rag.query_graphdb(max_deep=2, max_graph_items=30).print_result()
     ```
4. **重排搜索结果**: 根据问题和结果之间的相似度对搜索结果进行重排序。
     ```python
     graph_rag.merge_dedup_rerank().print_result()
     ```
5. **综合答案**: 总结结果并组织语言来回答问题。
    ```python
    graph_rag.synthesize_answer(vector_only_answer=False, graph_only_answer=True).print_result()
    ```
6. **运行**: `run` 方法用于执行上述操作。
    ```python
    graph_rag.run(verbose=True)
    ```