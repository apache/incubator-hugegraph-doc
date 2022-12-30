---
title: "Validate Apache Release"
linkTitle: "Validate Apache Release"
weight: 3
---
## verification phase

When the internal temporary release and packaging work is completed, other community developers (especially PMC) need to participate in the [verification link](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist)To ensure the "correctness + completeness" of someone's published version, here requires **everyone** to participate as much as possible, and then explain which items you have **checked** in the subsequent **email reply**. (The following are the core items)

#### 1. check hash value

First you need to check the file integrity of the `source + binary` package, Verify by `shasum` to ensure that it is consistent with the hash value published on apache/github (Usually sha512), Here is the same as the last step of 0x02 inspection.

#### 2. check gpg signature

This is to ensure that the published package is uploaded by a **reliable** person. Assuming tom signs and uploads, others should download A’s **public key** and then perform **signature confirmation**. Related commands:

```bash
# 1. Download the trusted public key of the project to the local (required for the first time)
curl xxx >> PK
gpg --import PK
# 1.2 Enter trust after waiting for the response to trust Tom's public key (other names are similar)
gpg -edit-key tom 

# 2. Check the signature (you can use the for loop script in step ⑧ of Chapter 0x03 to traverse in batches)
gpg --verify xx.asc xxx-source.tar.gz
gpg --verify xx.asc xxx-binary.tar.gz # Note: We currently do not have a binary suffix
```

First confirm the overall integrity/consistency, and then confirm the specific content (**key**)

#### 3. Check the archive contents

Here it is divided into two aspects: source code package + binary package, The source code package is more strict, it can be said that the core part (Because it is longer,For a complete list refer to the official [Wiki](https://cwiki.apache.org/confluence/display/INCUBATOR/Incubator+Release+Checklist))

First of all, we need to download the package from the apache official `release-candidate` URL to the local (URL: `dist.apache.org/repos/dist/dev/hugegraph/`)

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
# At the same time, you can also check whether the code style conforms to the specification, and if it does not conform, you can put down an adjustment
mvn clean test -Dcheckstyle.skip=false
```

##### B. binary package

After decompressing `xxx-hugegraph.tar.gz`, perform the following checks:

1. folders with `incubating`
2. `LICENSE` and `NOTICE` file exists and the content is normal
3. Confirm that the signature of each file is normal through the gpg command

**Note:** If a third-party dependency is introduced in the binary package, you need to update the LICENSE and add the third-party dependent LICENSE; if the third-party dependent LICENSE is Apache 2.0, and the corresponding project contains NOTICE, you also need to update Our NOTICE file

#### 4. Check the official website and github and other pages

1. Make sure that the official website at least meets [apache website check](https://whimsy.apache.org/pods/project/hugegraph), and no circular links etc.
2. Update **download link** and version update instructions
3. ...
