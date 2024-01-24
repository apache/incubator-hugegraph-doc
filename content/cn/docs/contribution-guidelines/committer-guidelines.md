---
title: "Apache HugeGraph Committer 指南"
linkTitle: "Apache HugeGraph Committer 指南"
weight: 5
---

> 本文档概述了 Apache Committer 推选要求以及流程，对应的官方文档可见: https://community.apache.org/newcommitter.html

# 候选人要求

1. 候选人应遵守 [Apache Code of Conduct](https://www.apache.org/foundation/policies/conduct.html)
2. PMC 成员将通过搜索[邮件列表](https://lists.apache.org/list?dev@hugegraph.apache.org)、[issues](https://github.com/apache/hugegraph/issues)、[PRs](https://github.com/apache/incubator-hugegraph/pulls)、[官网文档](https://hugegraph.apache.org/docs)等方式，了解候选人如何与他人互动，以及他们所做的贡献
3. 以下是在评估候选人是否适合成为 Committer 时需要考虑的一些要点：
   1. 与社区成员合作的能力
   2. 担任导师的能力
   3. 社区参与度
   4. 贡献程度
   5. 个人技能/能力


# 推选详细流程

**讨论 → 投票 → 邀请 → 公告**

## 发起社区邮件讨论

任何 HugeGraph 的 (P)PMC 成员都可以发起投票讨论，在发现社区贡献者任何有价值的贡献并取得候选人本人同意后，可以在 private@hugegraph.apache.org 发起讨论。讨论邮件里提议者要把候选人的贡献说清楚，并且给出复核对应贡献的地址，便于大家讨论分析。

下面是对应的邮件模板：

> 后续将使用 xxx 指代候选人，一般 `xxx` 为一个容易读的名字 (例如 `Simon Jay`)，`ASF-INFRA` 建议**避免**使用不易读的 `ID` 直接作为邮件**人名代指** (例如**避免** `simon321` 或 `wh0isSim0n` 😄)

```text
To: private@hugegraph.apache.org
Subject: [VOTE] New committer: xxx

Hi all:

I am pleased to nominate xxx for the role of HugeGraph Committer based on his contributions over the past few months.

[ Candidate's Contribution Summary ]

Here are the relevant PRs (issues) he has participated in:

**Core Features:**

[ Reference Links ]

**Fix/Chore/Release:**

[ Reference Links ]

**Doc:**

[ Reference Links ]

[ Candidate's Current Notable Contributions ]

His contributions bring the following benefits to the community, helping us in the following ways:

[ Candidate's Contributions and Benefits to the Community ]

In view of the above contributions, I elect xxx as Committer of the HugeGraph project.

[ Reference Links ]

Welcome everyone to share opinions~

Thanks!
```

对于讨论邮件中贡献链接，可以使用 [GitHub Search](https://github.com/search) 的统计功能，按需输入如下对应关键词查询即可，可以在此基础上添加新的 repo 如 `repo:apache/incubator-hugegraph-computer`，特别注意调整**时间范围** (下面是一个模板参考，请自行调整参数):

- PR 提交次数
  - `is:pr author:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- 代码提交/修改行数
  - https://github.com/apache/incubator-hugegraph/graphs/contributors?from=2023-06-01&to=2023-12-25&type=c
  - https://github.com/apache/incubator-hugegraph-doc/graphs/contributors?from=2023-06-01&to=2023-12-25&type=c
- PR 提交关联 Issue 次数
  - `linked:issue involves:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- PR Review 个数
  - `type:pr reviewed-by:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- PR Review 行数
- 合并次数
  - `type:pr author:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- 有效合并行数
  - https://github.com/apache/incubator-hugegraph/graphs/contributors?from=2023-06-01&to=2023-12-25&type=c
  - https://github.com/apache/incubator-hugegraph-doc/graphs/contributors?from=2023-06-01&to=2023-12-25&type=c
- Issue 提交数
  - `type:issue author:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- Issue 修复数
  - 在 Issue 提交数的基础上选取状态为 closed 的 Issues
- Issue 参与数
  - `type:issue involves:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- 评论 Issue 数
  - `type:issue commenter:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`
- 评论 PR 数
  - `type:pr commenter:xxx repo:apache/incubator-hugegraph repo:apache/incubator-hugegraph-doc created:>2023-06-01 updated:<2023-12-25`

Mailing Lists 可以使用 https://lists.apache.org/list?dev@hugegraph.apache.org:lte=10M:xxx 查询。

## 发起社区邮件投票

如果讨论邮件在规定时间内没有收到分歧信息，投票发起者需要在 private@hugegraph.apache.org 发起对 Committer 的选举投票。

下面是对应的邮件模板：

```text
To: private@hugegraph.apache.org
Subject: [VOTE] xxx as a HugeGraph Committer

Hi all:

Through the discussion of last week:
[ Discussion Mailing List Link ]

We have discussed and listed what xxx participated in the HugeGraph community.
I believe making him a Committer will enhance the work for HugeGraph. 

So, I am happy to call VOTE to accept xxx as a HugeGraph Committer.
 
Voting will continue for at least 72 hours or until the required number of votes is reached.
 
Please vote accordingly:
[ ] +1 approve
[ ] +0 no opinion
[ ] -1 disapprove with the reason  

Thanks!
```

## 宣布投票结果

投票邮件结束后，投票发起者需要邮件里提醒投票结束。同时，投票发起者需要发起邮件宣布投票结果，发送至 private@hugegraph.apache.org。

> TODO: 邮件模板

## 向候选人发起邮件邀请

宣布投票结果邮件发出后，投票发起人要给候选人发送邀请邮件。邀请邮件主送候选人，抄送 private@hugegraph.apache.org，被邀请的候选人必须通过指定的邮箱地址回复接受或者拒绝该邀请。

下面是对应的邮件模板：

```text
To: [ Candidate's Email ]
Cc: private@hugegraph.apache.org
Subject: Invitation to become HugeGraph committer: xxx

Hello xxx,

The HugeGraph Project Management Committee (PPMC)
hereby offers you committer privileges to the project.
These privileges are offered on the understanding that you'll use them
reasonably and with common sense. We like to work on trust
rather than unnecessary constraints.

Being a committer enables you to more easily make
changes without needing to go through the patch
submission process.

Being a committer does not require you to
participate any more than you already do. It does
tend to make one even more committed.  You will
probably find that you spend more time here.

Of course, you can decline and instead remain as a
contributor, participating as you do now.

A. This personal invitation is a chance for you to
accept or decline in private.  Either way, please
let us know in reply to the private@hugegraph.apache.org
address only.

B. If you accept, the next step is to register an iCLA:
    1. Details of the iCLA and the forms are found
    through this link: https://www.apache.org/licenses/#clas

    2. Instructions for its completion and return to
    the Secretary of the ASF are found at
    https://www.apache.org/licenses/#submitting

    3. When you transmit the completed iCLA, request
    to notify the Apache HugeGraph project and choose a
    unique Apache ID. Look to see if your preferred
    ID is already taken at
    https://people.apache.org/committer-index.html
    This will allow the Secretary to notify the PMC
    when your iCLA has been recorded.

When recording of your iCLA is noted, you will
receive a follow-up message with the next steps for
establishing you as a committer.

With the expectation of your acceptance, welcome!

The Apache HugeGraph(incubating) PPMC
```

## 候选人接受邀请

候选人应回复上述邮件 (选择 **reply all**)，表明接受邀请，邮件模板可参考：

```text
To: [ Sender's Email ]
Cc: private@hugegraph.apache.org
Subject: Re: Invitation to become HugeGraph committer: xxx

Hello Apache HugeGraph(incubating) PPMC,

I accept the invitation.

Thanks to the Apache HugeGraph Community for recognizing my work, I
will continue to actively participate in the work of the Apache
HugeGraph(incubating).

Next, I will follow the instructions to complete the next steps:
Signing and submitting iCLA and registering Apache ID.

xxx
```

当然，候选人也可以选择拒绝邀请。

一旦邀请被接受，候选人需要完成以下事项：

- 订阅 dev@hugegraph.apache.org，具体步骤请参考[文档](https://hugegraph.apache.org/docs/contribution-guidelines/subscribe/)
- 签署 [ICLA](https://www.apache.org/licenses/icla.pdf)，具体步骤如下

### ICLA 签署流程

1. 下载 [ICLA](https://www.apache.org/licenses/icla.pdf)
2. 打开 PDF 并填写相关内容，均需要全英文填写，建议使用 PDF 工具编辑并署名
   1. **Full name**: 名字在前，姓氏在后
   2. **Public name**: 可以不填，默认和 `Full name` 相同
   3. 勾选 check this box only if you entered names with your family name first
   4. **Postal Address**: 英文地址，从小地方到大地方的顺序来写，需详细到门牌号
   5. **Country:** 所在国家英文
   6. **E-mail**: 邮箱地址，建议与上述邮件中使用的邮箱相同
   7. **(optional) preferred Apache id(s)**: 选择一个 [Apache committer](http://people.apache.org/committer-index.html) 页面不存在的 **SVN ID**
   8. **(optional) notify project**：Apache HugeGraph(incubating)
   9. **签名：务必使用 PDF 工具手写**
   10. **Date:** 格式 xxxx-xx-xx
3. 签署完之后将 `icla.pdf` 重命名为 `姓名拼音-icla.pdf`
4. 发送下述邮件，并附件引用 `姓名拼音-icla.pdf`

```text
To: secretary@apache.org
Subject: ICLA Information

Hello everyone:

I have accepted the Apache HugeGraph(incubating) PPMC invitation to
become a HugeGraph committer, the attachment is my ICLA information.
My GitHub account is https://github.com/xxx. Thanks!

xxx
```

> 更多注意事项可参考 https://github.com/apache/incubator-hugegraph/issues/1732

PMC 成员将等待 Apache secretary 确认 ICLA 备案，候选人和 PMC 成员将收到以下电子邮件：

```text
Dear xxx,

This message acknowledges receipt of your ICLA, which has been filed in the Apache Software Foundation records.

Your account (with id xxx) has been requested for you and you should receive email with next steps
within the next few days (this process can take up to a week).

Please refer to https://www.apache.org/foundation/how-it-works.html#developers
for more information about roles at Apache.
```

### 设置 Apache 账号和开发环境

备案完成后，候选人将收到来自 root@apache.org 主题为 `Welcome to the Apache Software Foundation` 的邮件，此时需按照邮件中的步骤设置 Apache 账号和开发环境：

1. 重置密码 https://id.apache.org/reset/enter
2. 配置个人信息 https://whimsy.apache.org/roster/committer/xxx
3. 关联 GitHub 账号 https://gitbox.apache.org/boxer
   1. 这一步需要配置 GitHub 双重身份验证 (2FA)
4. **负责提名的 PMC 成员需通过 [Roster](https://whimsy.apache.org/roster/ppmc/hugegraph) 页面，将新的 Committer 添加到官方提交者列表中**
   1. 在这一步后，候选人即新的 Committer 才拥有对 GitHub HugeGraph 仓库的写权限
5. (可选) 新的 Committer 可以使用 Apache 账号[申请](https://www.jetbrains.com/shop/eform/apache)免费使用 Jetbrains 的全系列产品


## 发布公告邮件

TODO

# 参考

1. https://community.apache.org/newcommitter.html (官方文档)
2. https://infra.apache.org/new-committers-guide.html
3. https://www.apache.org/dev/pmc.html#newcommitter
4. https://linkis.apache.org/zh-CN/community/how-to-vote-a-committer-pmc
5. https://www.apache.org/licenses/contributor-agreements.html#submitting
6. https://www.apache.org/licenses/cla-faq.html#printer
7. https://linkis.apache.org/zh-CN/community/how-to-sign-apache-icla
8. https://github.com/apache/incubator-hugegraph/issues/1732 (HugeGraph ICLA related issue)
