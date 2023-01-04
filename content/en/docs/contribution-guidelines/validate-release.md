---
title: "Validate Apache Release"
linkTitle: "Validate Apache Release"
weight: 3
---

> Note: this doc will be updated continuously.

## Verification

When the internal temporary release and packaging work is completed, other community developers (especially PMC) need to participate in the [verification link](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist)To ensure the "correctness + completeness" of someone's published version, here requires **everyone** to participate as much as possible, and then explain which items you have **checked** in the subsequent **email reply**. (The following are the core items)

#### 1. prepare

If there is no svn or gpg environment locally, it is recommended to install it first (windows recommend using WSL2 environment, or at least `git-bash`)
```bash
# 1. install svn
# ubuntu/debian
sudo apt install subversion -y
# MacOS
brew install subversion
# To verify that the installation was successful, execute the following command:
svn --version

# 2. install gpg
# ubuntu/debian
sudo apt-get install gnupg -y
# MacOS
brew install gnupg
# To verify that the installation was successful, execute the following command:
gpg --version

# 3. Download the hugegraph-svn directory (version number, pay attention to fill in the verification version, here we take 1.0.0 as an example)
svn co https://dist.apache.org/repos/dist/dev/incubator/hugegraph/1.0.0/
# (Note) If svn downloads a file very slowly, you can consider wget to download a single file, as follows (or consider using a proxy)
wget https://dist.apache.org/repos/dist/dev/incubator/hugegraph/1.0.0/apache-hugegraph-toolchain-incubating-1.0.0.tar.gz
```

#### 2. check hash value

First you need to check the file integrity of the `source + binary` package, Verify by `shasum` to ensure that it is consistent with the hash value published on apache/github (Usually sha512), Here is the same as the last step of 0x02 inspection.
```bash
execute the following command:
for i in *.tar.gz; do echo $i; shasum -a 512 --check  $i.sha512; done
```

#### 3. check gpg signature

This is to ensure that the published package is uploaded by a **reliable** person. Assuming tom signs and uploads, others should download A’s **public key** and then perform **signature confirmation**. Related commands:

```bash
# 1. Download project trusted public key to local (required for the first time) & import
curl  https://downloads.apache.org/incubator/hugegraph/KEYS > KEYS
gpg --import KEYS

# After importing, you can see the following output, which means that 3 user public keys have been imported
gpg: /home/ubuntu/.gnupg/trustdb.gpg: trustdb created
gpg: key B78B058CC255F6DC: public key "Imba Jin (apache mail) <jin@apache.org>" imported
gpg: key 818108E7924549CC: public key "vaughn <vaughn@apache.org>" imported
gpg: key 28DCAED849C4180E: public key "coderzc (CODE SIGNING KEY) <zhaocong@apache.org>" imported
gpg: Total number processed: 3
gpg:               imported: 3

# 2. Trust release users (here you need to trust 3 users, perform the same operation for Imba Jin, vaughn, coderzc in turn)
gpg --edit-key Imba Jin # Take the first one as an example, enter the interactive mode
gpg> trust
...output options..
Your decision? 5 #select five
Do you really want to set this key to ultimate trust? (y/N) y #slect y, then q quits trusting the next user


# 3. Check the signature (make sure there is no Warning output, every source/binary file prompts Good Signature)
#Single file verification
gpg --verify xx.asc xxx-source.tar.gz
gpg --verify xx.asc xxx-binary.tar.gz # 注: 我们目前没有 binary 后缀
#for loop traversal verification (recommended)
for i in *.tar.gz; do echo $i; gpg --verify $i.asc $i ; done

```

First confirm the overall integrity/consistency, and then confirm the specific content (**key**)

#### 4. Check the archive contents

Here it is divided into two aspects: source code package + binary package, The source code package is stricter, it can be said that the core part (Because it is longer,For a complete list refer to the official [Wiki](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist))

First of all, we need to download the package from the apache official `release-candidate` URL to the local (URL: [click to jump](https://dist.apache.org/repos/dist/dev/incubator/hugegraph/))

##### A. source package

After decompressing `xxx-hugegraph-source.tar.gz`, Do the following checks:

1. folders with `incubating`, and no **empty** files/folders
2. `DISCLAIMER` file exists
3. `LICENSE` + `NOTICE` file exists and the content is normal
4. ** does not exist ** any binaries
5. The source code files all contain the standard `ASF License` header ((this can be done using a plugin))
6. Check whether the `pom.xml` version number of each parent/child module is consistent (and meet expectations)
7. Check the first 3 to 5 commits, click to see if the modification is consistent with the source file
8. Finally, make sure the source code works/compiles correctly (then look at tests and specs)

```bash
# prefer to use/switch to java 11 for the following operations (compiling/running)
# java --version

# try to test in the Unix env to check if it works well
mvn clean package -Dmaven.test.skip=true -Dcheckstyle.skip=true
```

##### B. binary package

After decompressing `xxx-hugegraph.tar.gz`, perform the following checks:

1. folders with `incubating`
2. `LICENSE` and `NOTICE` file exists and the content is normal
3. start server
```bash
# hugegraph-server
bin/start-hugegraph.sh

# hugegraph-loader
bin/hugegraph-loader.sh -f path -g graph -s schema

# hugegraph-hubble
bin/start-hubble.sh

# hugegraph-computer
bin/start-computer.sh -d local -r master

more reference official website: https://hugegraph.apache.org/cn/docs/quickstart
```

**Note:** If a third-party dependency is introduced in the binary package, you need to update the LICENSE and add the third-party dependent LICENSE; if the third-party dependent LICENSE is Apache 2.0, and the corresponding project contains NOTICE, you also need to update Our NOTICE file

#### 5. Check the official website and GitHub and other pages

1. Make sure that the official website at least meets [apache website check](https://whimsy.apache.org/pods/project/hugegraph), and no circular links etc.
2. Update **download link** and version update instructions
3. ...

## Mail Template

After the check & test, you should reply the mail with the following content: (normal devs & PMC)
```markdown
+1 (non-binding)
I checked:
1. All download links are valid
2. Checksum and signature are OK
3. LICENSE and NOTICE are exist
4. Build successfully on macOS(Big Sur) 
5. ....
```

and the PMC members should reply with `binding`, it's important for summary the valid votes:
```markdown
+1 (binding)
I checked:
1. All download links are valid
2. Checksum and signature are OK
3. LICENSE and NOTICE are exist
4. Build successfully on macOS(Big Sur) 
5. ....
```

