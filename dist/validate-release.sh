#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This script is used to validate the release package, including:
# 1. Check the release package name & content
# 2. Check the release package sha512 & gpg signature
# 3. Compile the source package & run server & toolchain
# 4. Run server & toolchain in binary package

set -e

# release version (input by committer)
RELEASE_VERSION=$1 # like 1.2.0
JAVA_VERSION=$2 # like 8
USER=$3

# this URL is only valid during the release process
SVN_URL_PREFIX="https://dist.apache.org/repos/dist/dev/incubator/hugegraph"

# git release branch (check it carefully)
#GIT_BRANCH="release-${RELEASE_VERSION}"

RELEASE_VERSION=${RELEASE_VERSION:?"Please input the release version, like 1.2.0"}
USER=${USER:-"imbajin"}
WORK_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${WORK_DIR}"
echo "Current work dir: $(pwd)"

################################
# Step 1: Download SVN Sources #
################################
rm -rf "${WORK_DIR}/dist/${RELEASE_VERSION}"
mkdir -p "${WORK_DIR}/dist/${RELEASE_VERSION}"
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"
svn co "${SVN_URL_PREFIX}/${RELEASE_VERSION}" .

##################################################
# Step 2: Check Environment & Import Public Keys #
##################################################
shasum --version 1>/dev/null
gpg --version 1>/dev/null

wget https://downloads.apache.org/incubator/hugegraph/KEYS
echo "Import KEYS:" && gpg --import KEYS
# TODO: how to trust all public keys in gpg list, currently only trust the first one
echo -e "5\ny\n" | gpg --batch --command-fd 0 --edit-key $USER trust

echo "trust all pk"
for key in $(gpg --no-tty --list-keys --with-colons | awk -F: '/^pub/ {print $5}'); do
  echo -e "5\ny\n" | gpg --batch --command-fd 0 --edit-key "$key" trust
done

########################################
# Step 3: Check SHA512 & GPG Signature #
########################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

for i in *.tar.gz; do
  echo "$i"
  shasum -a 512 --check "$i".sha512
  eval gpg "${GPG_OPT}" --verify "$i".asc "$i"
done

####################################
# Step 4: Validate Source Packages #
####################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

CATEGORY_X="\bGPL|\bLGPL|Sleepycat License|BSD-4-Clause|\bBCL\b|JSR-275|Amazon Software License|\bRSAL\b|\bQPL\b|\bSSPL|\bCPOL|\bNPL1|Creative Commons Non-Commercial"
CATEGORY_B="\bCDDL1|\bCPL|\bEPL|\bIPL|\bMPL|\bSPL|OSL-3.0|UnRAR License|Erlang Public License|\bOFL\b|Ubuntu Font License Version 1.0|IPA Font License Agreement v1.0|EPL2.0|CC-BY"
ls -lh ./*.tar.gz
for i in *src.tar.gz; do
  echo "$i"

  # 4.1: check the directory name include "incubating"
  if [[ ! "$i" =~ "incubating" ]]; then
    echo "The package name $i should include incubating" && exit 1
  fi

  tar -xzvf "$i"
  MODULE_DIR=$(basename "$i" .tar.gz)
  pushd ${MODULE_DIR}
  echo "Start to check the package content: ${MODULE_DIR}"

  # 4.2: check the directory include "NOTICE" and "LICENSE" file and "DISCLAIMER" file
  if [[ ! -f "LICENSE" ]]; then
    echo "The package $i should include LICENSE file" && exit 1
  fi
  if [[ ! -f "NOTICE" ]]; then
    echo "The package $i should include NOTICE file" && exit 1
  fi
  if [[ ! -f "DISCLAIMER" ]]; then
    echo "The package $i should include DISCLAIMER file" && exit 1
  fi

  # 4.3: ensure doesn't contains ASF CATEGORY X License dependencies in LICENSE and NOTICE files
  COUNT=$(grep -E "$CATEGORY_X" LICENSE NOTICE | wc -l)
  if [[ $COUNT -ne 0 ]]; then
     grep -E "$CATEGORY_X" LICENSE NOTICE
     echo "The package $i shouldn't include invalid ASF category X dependencies, but get $COUNT" && exit 1
  fi

  # 4.4: ensure doesn't contains ASF CATEGORY B License dependencies in LICENSE and NOTICE files
  COUNT=$(grep -E "$CATEGORY_B" LICENSE NOTICE | wc -l)
  if [[ $COUNT -ne 0 ]]; then
     grep -E "$CATEGORY_B" LICENSE NOTICE
     echo "The package $i shouldn't include invalid ASF category B dependencies, but get $COUNT" && exit 1
  fi

  # 4.5: ensure doesn't contains empty directory or file
  find . -type d -empty | while read -r EMPTY_DIR; do
    find . -type d -empty
    echo "The package $i shouldn't include empty directory: $EMPTY_DIR is empty" && exit 1
  done
  find . -type f -empty | while read -r EMPTY_FILE; do
    find . -type f -empty
    echo "The package $i shouldn't include empty file: $EMPTY_FILE is empty" && exit 1
  done

  # 4.6: ensure any file should less than 800kb
  find . -type f -size +800k | while read -r FILE; do
    find . -type f -size +800k
    echo "The package $i shouldn't include file larger than 800kb: $FILE is larger than 800kb" && exit 1
  done

  # 4.7: ensure all binary files are documented in LICENSE
  find . -type f | perl -lne 'print if -B' | while read -r BINARY_FILE; do
    FILE_NAME=$(basename "$BINARY_FILE")
    if grep -q "$FILE_NAME" LICENSE; then
      echo "Binary file $BINARY_FILE is documented in LICENSE, please check manually"
    else
      echo "Error: Binary file $BINARY_FILE is not documented in LICENSE" && exit 1
    fi
  done

  # 4.8: test compile the packages
  if [[ $JAVA_VERSION == 8 && "$i" =~ "computer" ]]; then
    echo "skip computer module in java8"
    popd
    continue
  fi
  # TODO: consider using commands that are entirely consistent with building binary packages
  mvn package -DskipTests -Papache-release -ntp -e
  ls -lh

  popd
done

###########################################
# Step 5: Run Compiled Packages of Server #
###########################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

ls -lh
pushd ./*hugegraph-incubating*src/hugegraph-server/*hugegraph*"${RELEASE_VERSION}"
bin/init-store.sh
sleep 3
bin/start-hugegraph.sh
popd

#######################################################################
# Step 6: Run Compiled Packages of ToolChain (Loader & Tool & Hubble) #
#######################################################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

pushd ./*toolchain*src
ls -lh
pushd ./*toolchain*"${RELEASE_VERSION}"
ls -lh

# 6.1: load some data first
echo "test loader"
pushd ./*loader*"${RELEASE_VERSION}"
bin/hugegraph-loader.sh -f ./example/file/struct.json -s ./example/file/schema.groovy \
  -g hugegraph
popd

# 6.2: try some gremlin query & api in tool
echo "test tool"
pushd ./*tool*"${RELEASE_VERSION}"
bin/hugegraph gremlin-execute --script 'g.V().count()'
bin/hugegraph task-list
bin/hugegraph backup -t all --directory ./backup-test
popd

# 6.3: start hubble and connect to server
echo "test hubble"
pushd ./*hubble*"${RELEASE_VERSION}"
# TODO: add hubble doc & test it
cat conf/hugegraph-hubble.properties
bin/start-hubble.sh
bin/stop-hubble.sh
popd

popd
popd
# stop server
pushd ./*hugegraph-incubating*src/hugegraph-server/*hugegraph*"${RELEASE_VERSION}"
bin/stop-hugegraph.sh
popd

# clear source packages
#rm -rf ./*src*
#ls -lh

####################################
# Step 7: Validate Binary Packages #
####################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

for i in *.tar.gz; do
  if [[ "$i" == *-src.tar.gz ]]; then
    # skip source packages
    continue
  fi

  echo "$i"

  # 7.1: check the directory name include "incubating"
  if [[ ! "$i" =~ "incubating" ]]; then
    echo "The package name $i should include incubating" && exit 1
  fi

  tar -xzvf "$i"
  MODULE_DIR=$(basename "$i" .tar.gz)
  pushd ${MODULE_DIR}
  ls -lh
  echo "Start to check the package content: ${MODULE_DIR}"

  # 7.2: check root dir include "NOTICE"/"LICENSE"/"DISCLAIMER" files & "licenses" dir
  if [[ ! -f "LICENSE" ]]; then
    echo "The package $i should include LICENSE file" && exit 1
  fi
  if [[ ! -f "NOTICE" ]]; then
    echo "The package $i should include NOTICE file" && exit 1
  fi
  if [[ ! -f "DISCLAIMER" ]]; then
    echo "The package $i should include DISCLAIMER file" && exit 1
  fi
  if [[ ! -d "licenses" ]]; then
    echo "The package $i should include licenses dir" && exit 1
  fi

  # 7.3: ensure doesn't contains ASF CATEGORY X License dependencies in LICENSE/NOTICE and licenses/* files
  COUNT=$(grep -r -E "$CATEGORY_X" LICENSE NOTICE licenses | wc -l)
  if [[ $COUNT -ne 0 ]]; then
    grep -r -E "$CATEGORY_X" LICENSE NOTICE licenses
    echo "The package $i shouldn't include invalid ASF category X dependencies, but get $COUNT" && exit 1
  fi

  # 7.4: ensure doesn't contains empty directory or file
  find . -type d -empty | while read -r EMPTY_DIR; do
    find . -type d -empty
    echo "The package $i shouldn't include empty directory: $EMPTY_DIR is empty" && exit 1
  done
  find . -type f -empty | while read -r EMPTY_FILE; do
    find . -type f -empty
    echo "The package $i shouldn't include empty file: $EMPTY_FILE is empty" && exit 1
  done

  popd
done

# TODO: skip the following steps by comparing the artifacts built from source packages with binary packages
#########################################
# Step 8: Run Binary Packages of Server #
#########################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

pushd ./*hugegraph-incubating*"${RELEASE_VERSION}"
bin/init-store.sh
sleep 3
bin/start-hugegraph.sh
popd

#####################################################################
# Step 9: Run Binary Packages of ToolChain (Loader & Tool & Hubble) #
#####################################################################
cd "${WORK_DIR}/dist/${RELEASE_VERSION}"

pushd ./*toolchain*"${RELEASE_VERSION}"
ls -lh

# 9.1: load some data first
echo "test loader"
pushd ./*loader*"${RELEASE_VERSION}"
bin/hugegraph-loader.sh -f ./example/file/struct.json -s ./example/file/schema.groovy -g hugegraph
popd

# 9.2: try some gremlin query & api in tool
echo "test tool"
pushd ./*tool*"${RELEASE_VERSION}"
bin/hugegraph gremlin-execute --script 'g.V().count()'
bin/hugegraph task-list
bin/hugegraph backup -t all --directory ./backup-test
popd

# 9.3: start hubble and connect to server
echo "test hubble"
pushd ./*hubble*"${RELEASE_VERSION}"
# TODO: add hubble doc & test it
cat conf/hugegraph-hubble.properties
bin/start-hubble.sh
bin/stop-hubble.sh
popd

popd
# stop server
pushd ./*hugegraph-incubating*"${RELEASE_VERSION}"
bin/stop-hugegraph.sh
popd

echo "Finish validate, please check all steps manually again!"
