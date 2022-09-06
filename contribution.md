# How to help us (如何帮助)
1. 参考后续文档, 在本地 3 步快速构建官网环境, 启动起来看下目前效果
2. 检查目前官网的 UI/内容/图标等是否合理 / 美观, 然后阅读 `docsy` 文档了解如何修改
3. 根据文档, 以及样例网站源码, 修改我们的网站 (或者提供**中/英文**翻译, 这个基本是 markdown 文档)
4. 先 fork 仓库, 然后基于 `master` 创建一个**新的**分支, 修改完成后提交 PR ✅ (请在 PR 内**截图**对比一下修改**前后**的效果 & 简要说明, 感谢)

Refer: 不熟悉 **github-pr** 流程的同学, 可以参考[贡献流程](https://github.com/apache/incubator-hugegraph/blob/master/CONTRIBUTING.md)文档, 最简单的方式是下 [github 桌面](https://desktop.github.com/)应用, 会简单方便许多~

**PS:** 可以参考其他官网的[源码](https://www.docsy.dev/docs/examples), 方便快速了解 docsy 主题结构.

# How to install the website (hugo)

Only 3 steps u can easily to get start~

U should ensure NPM & Hugo binary [download url](https://github.com/gohugoio/hugo/releases) before start, hugo binary must end with "**extended**" suffix, and we don't need install go env, just download hugo binary is fine

```bash
# 0. install npm & hugo if you don't have it

# Mac version (0.95 extend)
wget https://github.do/https://github.com/gohugoio/hugo/releases/download/v0.95.0/hugo_extended_0.95.0_macOS-64bit.tar.gz

# Linux version (0.95 extend)
wget https://github.do/https://github.com/gohugoio/hugo/releases/download/v0.95.0/hugo_extended_0.95.0_Linux-64bit.tar.gz

# 解压后 hugo 是单二进制文件, 可直接使用, 或推荐放 /usr/bin 及环境变量下.
sudo install hugo /usr/bin # 如果 mac 提示没有权限, 你可以直接使用它, 也可以 mv hugo /usr/bin 代替

# 1. download website's source code
git clone https://github.com/hugegraph/hugegraph-doc.git website

# if download slowly or failed, try the proxy url
git clone https://api.mtr.pub/hugegraph/hugegraph-doc.git website # or https://github.do/https://github.com/hugegraph/hugegraph-doc.git

# 2. install npm dependencies in project root dir
cd website && npm install

# 3. just start server in localhost now (Don't need do anything else)
hugo server

# (optional) if you want modify ip or port, try like this
hugo server -b http://127.0.0.1 -p 80 --bind=0.0.0.0

```

# How to modify the docsy theme (**Important**)

Here we need FE to modify / enhance the css/js/theme config, and we also need to translate doc and website

You can find detailed **theme instructions** in the [Docsy user guide - Content and Customization](https://www.docsy.dev/docs/adding-content/)

1. `config.toml` in the **root dir** is global config
2. `config.toml` in the `./themes/docsy` is theme config
3. `content` dir contains multi language contens (docs/index-html/blog/about/bg-imgage), it's the most important dir
    - `content/en` represent english site, we do need translate the `doc` in it (可先用 google 翻译, 紧急)
    - `content/cn` represent chinese site (需要汉化其中英文部分)

We can see some [example website](https://www.docsy.dev/docs/examples/) & refer to their github **source code** to reduce time to design

<img width="440" alt="image" src="https://user-images.githubusercontent.com/17706099/164688677-c2da2fc6-a88e-4786-a648-07a481cc8f9d.png">


## Troubleshooting

If you run into the following error:

```
➜ hugo server

Error: Error building site: TOCSS: failed to transform "scss/main.scss" (text/x-scss): resource "scss/scss/main.scss_9fadf33d895a46083cdd64396b57ef68" not found in file cache
```

This error occurs if you have not installed the extended version of [Hugo](https://github.com/gohugoio/hugo/releases).

[Docsy]: https://github.com/google/docsy
[example.docsy.dev]: https://example.docsy.dev
