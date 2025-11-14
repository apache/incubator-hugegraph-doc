# Apache HugeGraph 发版验证脚本

Apache HugeGraph (Incubating) 发布包的自动化验证脚本。

## 概述

`validate-release.sh` 脚本对 Apache HugeGraph 发布包进行全面验证，自动执行 [Apache 发布政策](https://www.apache.org/legal/release-policy.html) 和 [孵化器发布检查清单](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist) 要求的大部分检查。

## 功能特性

- ✅ **自动依赖检查** - 验证所有必需工具（svn、gpg、java、maven 等）
- ✅ **SHA512 和 GPG 签名验证** - 确保包的完整性和真实性
- ✅ **许可证合规性验证** - 检查禁止的 ASF Category X 和 B 类许可证
- ✅ **包内容验证** - 验证必需文件（LICENSE、NOTICE、DISCLAIMER）
- ✅ **ASF 许可证头检查** - 验证所有源文件中的许可证头（Java、Python、Go、Shell 等）
- ✅ **版本一致性验证** - 确保 pom.xml 版本与预期发布版本匹配
- ✅ **源码包编译** - 编译源码包以验证构建正确性
- ✅ **运行时测试** - 测试服务器和工具链（loader、tool、hubble）功能
- ✅ **进度跟踪** - 显示实时进度和分步指示器
- ✅ **详细日志记录** - 将所有输出保存到带时间戳的日志文件
- ✅ **全面的错误报告** - 收集所有错误并在最后显示摘要

## 环境要求

- Java 11（HugeGraph 1.5.0+ 必需）
- Maven 3.x
- svn（Subversion 客户端）
- gpg（用于签名验证的 GnuPG）
- wget 或 curl
- 标准 Unix 工具（bash、find、grep、awk 等）

脚本会自动检查所有依赖项，如果缺少任何内容会提供安装说明。

## 使用方法

### 基本用法

```bash
# 查看帮助信息
./validate-release.sh --help

# 从 Apache SVN 验证（自动下载发布文件）
./validate-release.sh <版本号> <apache-用户名>

# 示例
./validate-release.sh 1.7.0 pengjunzhi
```

### 高级用法

```bash
# 从本地目录验证（如果已经下载了文件）
./validate-release.sh <版本号> <apache-用户名> <本地路径>

# 示例
./validate-release.sh 1.7.0 pengjunzhi /path/to/downloaded/dist

# 指定 Java 版本（默认：11）
./validate-release.sh <版本号> <apache-用户名> <本地路径> <java-版本>

# 示例 - 使用 Java 11
./validate-release.sh 1.7.0 pengjunzhi /path/to/dist 11

# 示例 - SVN 模式使用 Java 11
./validate-release.sh 1.7.0 pengjunzhi "" 11

# 非交互模式（用于 CI/CD）
./validate-release.sh --non-interactive 1.7.0 pengjunzhi
```

### 命令行选项

- `--help`, `-h` - 显示帮助信息并退出
- `--version`, `-v` - 显示脚本版本并退出
- `--non-interactive` - 无提示运行（用于 CI/CD 管道）

## 验证步骤

脚本执行以下 9 个验证步骤：

1. **检查依赖项** - 验证所有必需工具已安装
2. **准备发布文件** - 从 Apache SVN 下载或使用本地目录
3. **导入并信任 GPG 密钥** - 导入 KEYS 文件并信任发布管理员的 GPG 密钥
4. **验证 SHA512 和 GPG 签名** - 验证所有包的校验和和签名
5. **验证源码包** - 对源码包进行全面检查：
   - 包命名（包含 "incubating"）
   - 必需文件（LICENSE、NOTICE、DISCLAIMER）
   - 许可证合规性（无 Category X，已记录 Category B）
   - 无空文件或目录
   - 文件大小限制（无文件 > 800KB）
   - 二进制文件文档
   - 所有源文件中的许可证头
   - pom.xml 文件之间的版本一致性
   - NOTICE 文件版权年份
   - 源码编译
6. **测试编译的服务器** - 启动并测试编译的 HugeGraph 服务器
7. **测试编译的工具链** - 从编译包测试 loader、tool 和 hubble
8. **验证二进制包** - 检查二进制包的必需文件和结构
9. **测试二进制包** - 从二进制包测试服务器和工具链

## 输出结果

### 进度指示器

脚本提供实时进度信息：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Apache HugeGraph Release Validation v2.0.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  版本:      1.7.0
  用户:      pengjunzhi
  Java:      11
  模式:      SVN 下载
  日志:      logs/validate-1.7.0-20251115-021742.log

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
步骤 [1/9]: 检查依赖项
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ svn: version 1.14.1
✓ gpg: gpg (GnuPG) 2.2.41
✓ java: 11.0.21
...
```

### 彩色结果

- ✓ **绿色** - 成功的检查
- ✗ **红色** - 需要修复的错误
- ⚠ **黄色** - 需要审查的警告
- **蓝色** - 步骤标题和进度信息

### 日志文件

所有输出都保存到 `logs/validate-<version>-<timestamp>.log` 以供后续查看。

### 最终摘要

验证结束时，会显示一个全面的摘要：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                    验证摘要
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

总检查数:  127
通过:      125
失败:      2
警告:      3

━━━ 错误 ━━━
  ✗ 包 'xyz' 缺少 LICENSE 文件
  ✗ 二进制文件 'logo.png' 未在 LICENSE 中记录

━━━ 警告 ━━━
  ⚠ NOTICE 文件可能不包含当前年份 (2025)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

验证失败
日志文件: logs/validate-1.7.0-20251115-021742.log
```

## 错误处理

脚本使用**"继续并报告"**方式：

- 不会在第一个错误时退出
- 收集所有验证错误
- 在最后显示全面摘要
- 退出码 0 = 所有检查通过
- 退出码 1 = 一个或多个检查失败

这允许你一次看到所有问题，而不是逐个修复。

## 故障排除

### Java 版本不匹配

如果看到 Java 版本错误：

```bash
# 检查你的 Java 版本
java -version

# 使用 JAVA_HOME 指定 Java 11
export JAVA_HOME=/path/to/java11
export PATH=$JAVA_HOME/bin:$PATH

# 或使用 jenv 切换 Java 版本
jenv global 11
```

### GPG 密钥问题

如果 GPG 密钥导入失败：

```bash
# 手动下载并导入 KEYS
curl https://downloads.apache.org/incubator/hugegraph/KEYS > KEYS
gpg --import KEYS

# 信任特定密钥
gpg --edit-key <user-email>
# 在 GPG 提示符中，输入: trust, 然后 5, 然后 y, 然后 quit
```

### 权限被拒绝

确保脚本可执行：

```bash
chmod +x validate-release.sh
```

## 参考文档

- [Apache 发布政策](https://www.apache.org/legal/release-policy.html)
- [孵化器发布检查清单](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist)
- [HugeGraph 验证发布指南](../content/cn/docs/contribution-guidelines/validate-release.md)

## 贡献

如果发现问题或有改进建议，请：

1. 查看现有问题：https://github.com/apache/incubator-hugegraph-doc/issues
2. 提交新问题或 pull request

