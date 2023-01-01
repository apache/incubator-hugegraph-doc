---
title: "验证 Apache 发版"
linkTitle: "验证 Apache 发版"
weight: 3
---

## 验证阶段

当内部的临时发布和打包工作完成后, 其他的社区开发者(尤其是 PMC)需要参与到[验证环节](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist)确保某个人发布版本的"正确性 + 完整性", 这里需要**每个人**都尽量参与, 然后后序**邮件回复**的时候说明自己**已检查**了哪些项. (下面是核心项)

#### 1. 准备工作

如果本地没有 svn 或 gpg 环境, 建议先安装一下 (windows 推荐使用 WSL2 环境, 或者至少是 `git-bash`)

```bash
# 1. 安装svn
# ubuntu/debian
sudo apt install subversion -y
# MacOS
brew install subversion
# 验证安装是否成功, 执行以下命令:
svn --version

# 2. 安装gpg
# ubuntu/debian
sudo apt-get install gnupg -y
# MacOS
brew install gnupg
# 验证安装是否成功, 执行以下命令:
gpg --version

# 3. 下载 hugegraph-svn 目录 (版本号注意填写此次验证版本, 这里以1.0.0为例)
svn co https://dist.apache.org/repos/dist/dev/incubator/hugegraph/1.0.0/
# (注) 如果出现 svn 下载某个文件速度很慢的情况, 可以考虑 wget 单个文件下载, 如下 (或考虑使用代理)
wget https://dist.apache.org/repos/dist/dev/incubator/hugegraph/1.0.0/apache-hugegraph-toolchain-incubating-1.0.0.tar.gz
```

#### 2. 检查 hash 值

首先需要检查 `source + binary` 包的文件完整性, 通过 `shasum` 进行校验, 确保和发布到 apache/github 上的 hash 值一致 (一般是 sha512)

```bash
执行命令:
for i in *.tar.gz; do echo $i; shasum -a 512 --check  $i.sha512; done
```
#### 3. 检查 gpg 签名

这个就是为了确保发布的包是由**可信赖**的人上传的, 假设 tom 签名后上传, 其他人应该下载 A 的**公钥**然后进行**签名确认**, 相关命令:

```bash
# 1. 下载项目可信赖公钥到本地 (首次需要) & 导入
curl  https://downloads.apache.org/incubator/hugegraph/KEYS > KEYS
gpg --import KEYS

# 导入后可以看到如下输出, 这代表导入了 3 个用户公钥
gpg: /home/ubuntu/.gnupg/trustdb.gpg: trustdb created
gpg: key B78B058CC255F6DC: public key "Imba Jin (apache mail) <jin@apache.org>" imported
gpg: key 818108E7924549CC: public key "vaughn <vaughn@apache.org>" imported
gpg: key 28DCAED849C4180E: public key "coderzc (CODE SIGNING KEY) <zhaocong@apache.org>" imported
gpg: Total number processed: 3
gpg:               imported: 3

# 2. 信任发版用户 (这里需要信任 3 个, 对 Imba Jin, vaughn, coderzc 依次执行相同操作)
gpg --edit-key Imba Jin # 以第一个为例, 进入交互模式
gpg> trust
...输出选项..
Your decision? 5 #选择5
Do you really want to set this key to ultimate trust? (y/N) y #选择y, 然后 q 退出信任下一个用户


# 3. 检查签名(确保没有 Warning 输出, 每一个 source/binary 文件都提示 Good Signature)
#单个文件验证
gpg --verify xx.asc xxx-source.tar.gz
gpg --verify xx.asc xxx-binary.tar.gz # 注: 我们目前没有 binary 后缀
#for循环遍历验证(推荐使用)
for i in *.tar.gz; do echo $i; gpg --verify $i.asc $i ; done

```

先确认了整体的"完整性 + 一致性", 然后接下来确认具体的内容 (**关键**)

#### 4. 检查压缩包内容

这里分源码包 + 二进制包两个方面, 源码包更为严格, 挑核心的部分说 (完整的列表可参考官方 [Wiki](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist), 比较长)

首先我们需要从 apache 官方的 `release-candidate` 地址下载包到本地 (地址: [点击跳转](https://dist.apache.org/repos/dist/dev/incubator/hugegraph/))

##### A. 源码包

解压 `xxx-hugegraph-source.tar.gz`后, 进行如下检查:

1. 文件夹都带有 `incubating`, 且不存在**空的**文件/文件夹
2. 存在`DISCLAIMER`文件
3. 存在 `LICENSE` + `NOTICE` 文件并且内容正常
4. **不存在**任何二进制文件
5. 源码文件都包含标准 `ASF License` 头 (这个用插件跑一下为主)
6. 检查每个父/子模块的 `pom.xml` 版本号是否一致 (且符合期望)
7. 检查前 3 ~ 5 个 commit 提交, 点进去看看是否修改处和源码文件一致
8. 最后, 确保源码可以正常/正确编译 (然后看看测试和规范)

```bash
# 请优先使用/切换到 java 11 版本进行后序的编译和运行操作
# java --version

# 尝试在 Unix 环境下编译测试是否正常
mvn clean package -Dmaven.test.skip=true -Dcheckstyle.skip=true
```

##### B. 二进制包

解压 `xxx-hugegraph.tar.gz`后, 进行如下检查:

1. 文件夹都带有 `incubating`
2. 存在 `LICENSE` + `NOTICE` 文件并且内容正常

**注:** 如果二进制包里面引入了第三方依赖, 则需要更新 LICENSE, 加入第三方依赖的 LICENSE; 若第三方依赖 LICENSE 是 Apache 2.0, 且对应的项目中包含了 NOTICE, 则还需要更新我们的 NOTICE 文件

#### 5. 检查官网以及 github 等页面

1. 确保官网至少满足 [apache website check](https://whimsy.apache.org/pods/project/hugegraph), 以及没有死链等
2. 更新**下载链接**以及版本更新说明
3. ...
