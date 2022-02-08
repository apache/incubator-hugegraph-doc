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
# The encrypted file path
export ENCRYPTED_FILE='/home/crypt-data/encryptfs'
 
# The encrypted file size
export ENCRYPTED_FILE_SIZE=5G

# Choose the first available loop device
export LOOP_DEVICE=$(losetup -f)
 
# The mapper file name
export MAPPER_FILE='hstorage'
 
# The mount path
export MOUNT_PATH='/mnt/encryptfs'
```

- 创建数据存储的文件

```bash
dd of=$ENCRYPTED_FILE bs=$ENCRYPTED_FILE_SIZE count=0 seek=1
```

- 关联文件与设备

```bash
sudo losetup $LOOP_DEVICE $ENCRYPTED_FILE
```

- 加密设备中的存储，注意输入'YES'，并牢记输入的密码

```bash
sudo cryptsetup -y luksFormat $LOOP_DEVICE
```

- 打开分区，创建到$ENCRYPTED_FILE的映射

```bash
sudo cryptsetup open $LOOP_DEVICE $MAPPER_FILE
```

- 创建文件系统

```bash
sudo mke2fs -j -O dir_index /dev/mapper/$MAPPER_FILE
```

- 挂载文件系统

```bash
sudo mkdir -p $MOUNT_PATH
sudo mount /dev/mapper/$MAPPER_FILE $MOUNT_PATH
```

#### 例子2：使用eCryptfs进行文件系统加密

- 安装eCryptfs

- 设置环境变量，如下所示

```bash
# The path of encrypted directory
export ENCRYPTED_HSTORE_PATH='<path-to-encrypted-directory>'

# The mount directory
export MOUNT_PATH='<path-to-mount-directory>'
```

- 挂载，并将Hstore的存储目录指向$MOUNT_PATH

注意：挂在口上过程中需要输入密码

```bash
sudo mount -t ecryptfs $ENCRYPTED_HSTORE_PATH $MOUNT_PATH
```
