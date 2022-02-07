## 加密数据

### 加密级别

HugeGraph支持与行业标准方法集成，以便在存储在磁盘中时对数据进行加密。数据加密可以应用于不同的级别。用户可以选择使用一个或多个级别。

|  加密级别   | 描述 |  备注  |
|  ----  | ---|  ----  |
| 硬件级别  |使用专用硬盘，在写入时自动加密，在读取时自动解密（由授权操作系统用户）| 对HugeGraph透明 |
| 内核级别  |使用Linux内置程序加密数据，需要root权限 | 对HugeGraph透明 |
| 用户级别  |使用Linux内置的程序和定制的库来加密数据，不需要Root权限 | 对HugeGraph透明 |

#### 硬件级别加密
需要硬件支持。

#### 内核级别加密

运行在内核模式下，需要超级用户权限，一些工具允许用户从加密算法列表中选择加密文件系统的加密算法。例如Ubuntu操作系统中，在操作系统安装过程中可以选择全磁盘加密。对于其他Linux发行版，可以使用dm encrypt对磁盘进行加密。还有一些其他的工具比如eCryptfs也可以用于文件系统加密。

#### 用户级别加密

若超级用户权限不可用，那么可以使用FUSE（用户空间中的文件系统）创建一个运行在主机操作系统之上的用户级文件系统，缺点是性能有所降低。

### 例子

#### 例子1：使用dm crypt的进行内核模式下文件系统加密

在本例中，使用dm crypt提供内核模式的文件系统加密。dm crypt不仅提供加密算法的选择，而且还可以选择为不同级别的存储单元提供加密的能力，例如完整磁盘、分区、逻辑卷或文件。

本例中的基本思想是创建一个文件，将一个加密的文件系统映射到该文件，并将其装载为HugeGraph的存储目录，仅对授权用户具有R/W权限。

###### 要求 

  1. 需要超级管理员（root）权限
  2. 足够的空间用于存储被加密数据

###### 安装说明

- 安装cryptsetup
  
- 设置环境变量，如下所示

```bash
# The username for HugeGraph Database System
export USER_NAME='<username>'

# The path of encrypted file to be created for HugeGraph storage
export ENCRYPTED_FILE_PATH='<path-to-encrypted-file>'

# The size of encrypted file to be created, for example: 60G
export ENCRYPTED_FILE_SIZE=<storage-size>

# The password for the encrypted file, for example: MataAtRe5tPa55w0rd
export ENCRYPTED_PASSWORD='<password>'

# The root directory for hugegraph, for example: $HOME/hugegraph
export HUGEGRAPH_DATA_ROOT="<hugegraph-data-root>"

# Set the first available loop device for encrypted file mapping
export LOOP_DEVICE=$(losetup -f)
```

- 创建数据存储的文件

```bash
dd of=$ENCRYPTED_FILE_PATH bs=$ENCRYPTED_FILE_SIZE count=0 seek=1
```

- 更改文件访问权限

```bash
chmod 600 $ENCRYPTED_FILE_PATH
```

- 关联文件与设备

```bash
sudo losetup $LOOP_DEVICE $ENCRYPTED_FILE_PATH
```

- 加密设备中的存储

```bash
echo "$ENCRYPTED_PASSWORD" | cryptsetup -y luksFormat $LOOP_DEVICE
```

- 打开分区，创建到$ENCRYPTED_FILE_PATH的映射

```bash
echo "$ENCRYPTED_PASSWORD" | cryptsetup luksOpen $LOOP_DEVICE hugegraph_hstore
```

- 创建文件系统

```bash
sudo mke2fs -j -O dir_index /dev/mapper/hugegraph_hstore
```

- 挂载文件系统到指定位置 /mnt/hstore

```bash
sudo mount /dev/mapper/hugegraph_hstore /mnt/hstore
```

#### 例子2：使用eCryptfs进行文件系统加密

- 安装eCryptfs

- 设置环境变量，如下所示

```bash
# The path of encrypted directory
export ENCRYPTED_HSTORE_PATH='<path-to-encrypted-directory>'

# The mount directory
export MOUNT_DIRECTORY='<path-to-mount-directory>'
```

- 挂载，并将Hstore的存储目录指向$MOUNT_DIRECTORY

注意：挂在口上过程中需要输入密码

```bash
sudo mount -t ecryptfs $ENCRYPTED_HSTORE_PATH $MOUNT_DIRECTORY
```
