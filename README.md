# How to help us (如何帮助)
1. 本地构建官网环境, 并启动起来
2. 看看目前官网的 UI 是否合理 / 美观, 然后阅读 `docsy` 的自定义文档
3. 根据文档, 以及样例网站源码, 修改我们的网站 (或者提供**中/英文**翻译, 这个基本是 markdown 文档)

# How to install the website (hugo)

Only 3 steps u can easily to get start~

U should ensure NPM & Hugo binary [download url](https://github.com/gohugoio/hugo/releases) before start, hugo binary must end with "**extended**" suffix, and we don't need install go env, just download hugo binary is fine

```bash
# 0. install npm & hugo if you don't have it

# Mac version (0.95 extend)
wget https://github.do/https://github.com/gohugoio/hugo/releases/download/v0.95.0/hugo_extended_0.95.0_macOS-64bit.tar.gz

# Linux version (0.95 extend)
wget https://github.do/https://github.com/gohugoio/hugo/releases/download/v0.95.0/hugo_extended_0.95.0_Linux-64bit.tar.gz
# 解压后 hugo 是单二进制文件可直接放 /usr/bin 下
sudo install hugo /usr/bin

# 1. download source code & cd it
git clone -b website https://github.com/hugegraph/hugegraph-doc.git website

# if download slowly or failed, try the proxy url
git clone -b website https://api.mtr.pub/hugegraph/hugegraph-doc.git website # or https://github.do/https://github.com/hugegraph/hugegraph-doc.git

# 2. we need install npm dependencies in project root dir
cd website && npm install

# 3. we could just start hugo server in localhost now (u don't need do anything else)
hugo server

# (optional) if you want modify ip or port, try like this
hugo server -b http://127.0.0.1 -p  80 --bind=0.0.0.0

```

# How to modify the docsy theme (**Important**)

Here we need FE to modify / enhance the css/js/theme config, and we also need to translate doc and website

You can find detailed **theme instructions** in the [Docsy user guide - Content and Customization](https://www.docsy.dev/docs/adding-content/)

1. `config.toml` in the **root dir** is global config
2. `config.toml` in the `./themes/docsy` is theme config
3. `content` dir contains multi language contens (docs/index-html/blog/about/bg-imgage), it's the most important dir

We can see some [example website](https://www.docsy.dev/docs/examples/) & refer to their source code to reduce time to design

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
