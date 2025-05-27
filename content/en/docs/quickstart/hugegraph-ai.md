---
title: "HugeGraph-AI Quick Start"
linkTitle: "Explore with HugeGraph-AI"
weight: 4
---

## 1 HugeGraph-AI Overview
hugegraph-ai aims to explore the integration of HugeGraph and artificial intelligence (AI), including applications combined 
with large models, integration with graph machine learning components, etc., to provide comprehensive support for developers to use HugeGraph's AI capabilities in projects.

## 2 Environment Requirements
- Python 3.9+ (better to use `3.10`)  
- HugeGraph Server 1.3+

## 3 Preparation

1. Start the HugeGraph database, you can run it via [Docker](https://hub.docker.com/r/hugegraph/hugegraph)/[Binary Package](https://hugegraph.apache.org/docs/download/download/).  
    Refer to detailed [doc](https://hugegraph.apache.org/docs/quickstart/hugegraph-server/#31-use-docker-container-convenient-for-testdev) for more guidance

2. **Docker Deployment**  
   If you wish to deploy HugeGraph-AI using Docker, follow these steps:
   - Ensure you have Docker installed.
   - In the project root directory, use the following command to pull the remote Docker container images. We provide two container images:
     - **Image 1**: [hugegraph/rag](https://hub.docker.com/r/hugegraph/rag/tags)  
       This image is used to build and run the RAG (Retrieval-Augmented Generation) functionality of HugeGraph-AI, suitable for users who need quick deployment and usage.
     - **Image 2**: [hugegraph/rag-bin](https://hub.docker.com/r/hugegraph/rag-bin/tags)  
       This image provides a binary version of HugeGraph-AI, suitable for users who require more stable and efficient performance.
   - Use the following command to pull the remote Docker container images:
     ```bash
     docker pull hugegraph/rag:latest # Pull Image 1
     docker pull hugegraph/rag-bin:latest # Pull Image 2
     ```
   - Use the following command to start the Docker container:
     ```bash
     docker run -it --name rag -p 8001:8001 hugegraph/rag bash
     docker run -it --name rag -p 8001:8001 hugegraph/rag-bin bash
     ```
   - Start the **Graph RAG** gradio interactive demo using the following command:
     ```bash
     python ./src/hugegraph_llm/demo/rag_demo/app.py # Start demo in the container created by Image 1
     ```
     ```bash
     ./app.dist/app.bin # Start demo in the container created by Image 2
     ```
   - After starting, you can access the HugeGraph-AI interactive interface at http://localhost:8001.

3. Clone the project
    ```bash
    git clone https://github.com/apache/incubator-hugegraph-ai.git
    ```

4. Install [hugegraph-python-client](../hugegraph-python-client) and [hugegraph_llm](src/hugegraph_llm)
    ```bash
    cd ./incubator-hugegraph-ai # better to use virtualenv (source venv/bin/activate) 
    pip install ./hugegraph-python-client
    pip install -r ./hugegraph-llm/requirements.txt
    ```

5. Enter the project directory
    ```bash
    cd ./hugegraph-llm/src
    ```

6. Start the **Graph RAG** gradio interactive demo using the following command, which will open http://127.0.0.1:8001
    ```bash
    python3 -m hugegraph_llm.demo.rag_demo.app
    ```
    The default host is `0.0.0.0`, and the port is `8001`. You can change them by passing the command-line arguments `--host` and `--port`.
    ```bash
    python3 -m hugegraph_llm.demo.rag_demo.app --host 127.0.0.1 --port 18001
    ```

7. Start the **Text2Gremlin** gradio interactive demo using the following command, which will open http://127.0.0.1:8002. You can also change the default host `0.0.0.0` and port `8002` as described above. (🚧ing)
    ```bash
    python3 -m hugegraph_llm.demo.gremlin_generate_web_demo
   ```

8. After running the demo program, the configuration file will be deleted. The `.env` file will be automatically generated in the `hugegraph-llm/.env` path. Additionally, there is a prompt-related configuration file `config_prompt.yaml` that will also be generated in the `hugegraph-llm/src/hugegraph_llm/resources/demo/config_prompt.yaml` path.
    You can modify the content on the page, and the changes will be automatically saved to the configuration file after triggering the corresponding function. You can also directly modify the file without restarting the application; just refresh the page to load the latest changes.
    (Optional) To regenerate the configuration file, you can use `config.generate` with `-u` or `--update`.
    ```bash
    python3 -m hugegraph_llm.config.generate --update
    ```

9. (**Optional**) You can use [hugegraph-hubble](https://hugegraph.apache.org/docs/quickstart/hugegraph-hubble/#21-use-docker-convenient-for-testdev) to access graph data, which can be run via [Docker/Docker-Compose](https://hub.docker.com/r/hugegraph/hubble) for guidance. (Hubble is a graph analysis dashboard, including data loading, schema management, graph traversal, and display).

10. (__Optional__) Download NLTK stopwords offline
    ```bash
    python ./hugegraph_llm/operators/common_op/nltk_helper.py
    ```

## 4 Examples 
### 4.1 Building a Knowledge Graph in HugeGraph via LLM
#### 4.1.1 Building a Knowledge Graph via the Gradio Interactive Interface

**Parameter Description:**  

- Docs:
  - text: Build a RAG index from plain text
  - file: Upload files: <u>TXT</u> or <u>.docx</u> (you can select multiple files at once)
- [Schema](https://hugegraph.apache.org/docs/clients/restful-api/schema/): (accepts **2 types**)
  - User-defined schema (JSON format, follow the [template](https://github.com/apache/incubator-hugegraph-ai/blob/aff3bbe25fa91c3414947a196131be812c20ef11/hugegraph-llm/src/hugegraph_llm/config/config_data.py#L125) to modify it)
  - Specify the name of the HugeGraph instance, which will automatically retrieve the schema from it (e.g., **"hugegraph"**)
- Graph extract head: User-defined graph extraction prompt
- If graph data already exists, you should click "**Rebuild vid Index**" to update the index

![gradio-config](/docs/images/gradio-kg.png)

##### 4.1.2 Building a Knowledge Graph via Code

The `KgBuilder` class is used to build a knowledge graph. Here is the usage process:

1. **Initialization**: The `KgBuilder` class is initialized with an instance of a language model. This can be obtained from the `LLMs` class.
   Initialize the `LLMs` instance, get the `LLM`, and then create a task instance `KgBuilder` for graph construction. `KgBuilder` defines multiple operators, which users can freely combine as needed. (Tip: `print_result()` can print the results of each step in the console without affecting the overall execution logic)
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
2. **Import Schema**: The `import_schema` method is used to import the schema from a source. The source can be a HugeGraph instance, a user-defined schema, or an extraction result. You can link the `print_result` method to print the results.
    ```python
    # Import schema from a HugeGraph instance
    builder.import_schema(from_hugegraph="xxx").print_result()
    # Import schema from an extraction result
    builder.import_schema(from_extraction="xxx").print_result()
    # Import schema from user-defined schema
    builder.import_schema(from_user_defined="xxx").print_result()
    ```
3. **Chunk Split**: The `chunk_split` method is used to split the input text into chunks. The text should be passed as a string parameter to the method.
    ```python
    # Split the input text into documents
    builder.chunk_split(TEXT, split_type="document").print_result()
    # Split the input text into paragraphs
    builder.chunk_split(TEXT, split_type="paragraph").print_result()
    # Split the input text into sentences
    builder.chunk_split(TEXT, split_type="sentence").print_result()
    ```
4. **Information Extraction**: The `extract_info` method is used to extract information from the text. The text should be passed as a string parameter to the method.
    ```python
    TEXT = "Meet Sarah, a 30-year-old attorney, and her roommate, James, whom she's shared a home with since 2010."
    # extract property graph from the input text
    builder.extract_info(extract_type="property_graph").print_result()
    # extract triples from the input text
    builder.extract_info(extract_type="property_graph").print_result()
    ```
5. **Commit to HugeGraph**: The `commit_to_hugegraph` method is used to commit the constructed knowledge graph to the HugeGraph instance.
    ```python
    builder.commit_to_hugegraph().print_result()
    ```
6. **Run**: The `run` method is used to execute the chained operations.
    ```python
    builder.run()
    ```
    The methods of the `KgBuilder` class can be chained together to perform a series of operations.

#### 4.2 Retrieval-Augmented Generation (RAG) Based on HugeGraph

The `RAGPipeline` class is used to integrate HugeGraph with large language models to provide retrieval-augmented generation functionality. Here is the usage process:

1. **Extract Keywords**: Extract keywords and expand synonyms.
    ```python
    from hugegraph_llm.operators.graph_rag_task import RAGPipeline
    graph_rag = RAGPipeline()
    graph_rag.extract_keywords(text="Tell me about Al Pacino.").print_result()
    ```
2. **Match Keywords to Vid**: Match nodes with keywords in the graph.
	```python
    graph_rag.keywords_to_vid().print_result()
   ```
3. **Query Graph for RAG**: Retrieve corresponding keywords and their multi-degree relationships from HugeGraph.
     ```python
     graph_rag.query_graphdb(max_deep=2, max_items=30).print_result()
     ```
4. **Reorder Search Results**: Reorder the search results based on the similarity between the question and the results.
    ```python
    graph_rag.merge_dedup_rerank().print_result()
    ```
5. **Synthesize Answer**: Summarize the results and organize the language to answer the question.
    ```python
    graph_rag.synthesize_answer(vector_only_answer=False, graph_only_answer=True).print_result()
    ```
6. **Run**: The `run` method is used to execute the above operations.
    ```python
    graph_rag.run(verbose=True)
    ```
