# Apache HugeGraph Documentation Website

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/apache/hugegraph-doc)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Hugo](https://img.shields.io/badge/Hugo-Extended-ff4088?logo=hugo)](https://gohugo.io/)

---

**中文** | [English](#english-version)

这是 [HugeGraph 官方文档网站](https://hugegraph.apache.org/docs/) 的**源代码仓库**。

如果你想查找 HugeGraph 数据库本身，请访问 [apache/hugegraph](https://github.com/apache/hugegraph)。

## 快速开始

只需 **3 步**即可在本地启动文档网站：

**前置条件：** [Hugo Extended](https://github.com/gohugoio/hugo/releases) v0.95+ 和 Node.js v16+

```bash
# 1. 克隆仓库
git clone https://github.com/apache/hugegraph-doc.git
cd hugegraph-doc

# 2. 安装依赖
npm install

# 3. 启动开发服务器（支持热重载）
hugo server
```

打开 http://localhost:1313 预览网站。

> **常见问题：** 如果遇到 `TOCSS: failed to transform "scss/main.scss"` 错误，
> 说明你需要安装 Hugo **Extended** 版本，而不是标准版本。

## 仓库结构

```
hugegraph-doc/
├── content/                    # 📄 文档内容 (Markdown)
│   ├── cn/                     # 🇨🇳 中文文档
│   │   ├── docs/               #    主要文档目录
│   │   │   ├── quickstart/     #    快速开始指南
│   │   │   ├── config/         #    配置文档
│   │   │   ├── clients/        #    客户端文档
│   │   │   ├── guides/         #    使用指南
│   │   │   └── ...
│   │   ├── blog/               #    博客文章
│   │   └── community/          #    社区页面
│   └── en/                     # 🇺🇸 英文文档（与 cn/ 结构一致）
│
├── themes/docsy/               # 🎨 Docsy 主题 (git submodule)
├── assets/                     # 🖼️  自定义资源 (fonts, images, scss)
├── layouts/                    # 📐 Hugo 模板覆盖
├── static/                     # 📁 静态文件
├── config.toml                 # ⚙️  站点配置
└── package.json                # 📦 Node.js 依赖
```

## 如何贡献

### 贡献流程

1. **Fork** 本仓库
2. 基于 `master` 创建**新分支**
3. 修改文档内容
4. 提交 **Pull Request**（附截图）

### 重要说明

| 要求 | 说明 |
|------|------|
| **双语更新** | 修改内容时需**同时更新** `content/cn/` 和 `content/en/` |
| **PR 截图** | 提交 PR 时需附上修改**前后对比截图** |
| **Markdown** | 文档使用 Markdown 格式，带 Hugo front matter |

### 详细指南

查看 [contribution.md](./contribution.md) 了解：
- 各平台 Hugo 安装方法
- Docsy 主题定制
- 翻译技巧

## 常用命令

| 命令 | 说明 |
|------|------|
| `hugo server` | 启动开发服务器（热重载） |
| `hugo --minify` | 构建生产版本到 `./public/` |
| `hugo server -p 8080` | 指定端口 |

## 联系我们

- **问题反馈：** [GitHub Issues](https://github.com/apache/hugegraph-doc/issues)
- **邮件列表：** [dev@hugegraph.apache.org](mailto:dev@hugegraph.apache.org)（[需先订阅](https://hugegraph.apache.org/docs/contribution-guidelines/subscribe/)）
- **Slack：** [ASF Slack](https://the-asf.slack.com/archives/C059UU2FJ23)
- **微信公众号：** Apache HugeGraph

<img src="./assets/images/wechat.png" alt="WeChat QR Code" width="350"/>

### 贡献者

感谢所有为 HugeGraph 文档做出贡献的人！

[![contributors](https://contrib.rocks/image?repo=apache/hugegraph-doc)](https://github.com/apache/hugegraph-doc/graphs/contributors)

---

## English Version

This is the **source code repository** for the [HugeGraph documentation website](https://hugegraph.apache.org/docs/).

For the HugeGraph database project, visit [apache/hugegraph](https://github.com/apache/hugegraph).

### Quick Start

**Prerequisites:** [Hugo Extended](https://github.com/gohugoio/hugo/releases) v0.95+ and Node.js v16+

```bash
# 1. Clone repository
git clone https://github.com/apache/hugegraph-doc.git
cd hugegraph-doc

# 2. Install dependencies
npm install

# 3. Start development server (auto-reload)
hugo server
```

Open http://localhost:1313 to preview.

> **Troubleshooting:** If you see `TOCSS: failed to transform "scss/main.scss"`,
> install Hugo **Extended** version, not the standard version.

### Contributing

1. **Fork** this repository
2. Create a **new branch** from `master`
3. Make your changes
4. Submit a **Pull Request** with screenshots

**Requirements:**
- Update **BOTH** `content/cn/` and `content/en/`
- Include **before/after screenshots** in PR
- Use Markdown with Hugo front matter

See [contribution.md](./contribution.md) for detailed instructions.

---

## License

[Apache License 2.0](LICENSE)
