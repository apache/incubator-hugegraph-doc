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

URL_PREFIX="https://dist.apache.org/repos/dist/dev/incubator/hugegraph/"
# release version (input by committer)
RELEASE_VERSION=$1
JAVA_VERSION=$2
USER=$3
# git release branch (check it carefully)
#GIT_BRANCH="release-${RELEASE_VERSION}"

RELEASE_VERSION=${RELEASE_VERSION:?"Please input the release version behind script"}
WORK_DIR=$(
  cd "$(dirname "$0")" || exit
  pwd
)

cd "${WORK_DIR}" || exit
echo "Current work dir: $(pwd)"

################################
# Step 1: Download SVN Sources #
################################
rm -rf "$WORK_DIR"/dist/"$RELEASE_VERSION"
svn co ${URL_PREFIX}/"$RELEASE_VERSION" "$WORK_DIR"/dist/"$RELEASE_VERSION"

##################################################
# Step 2: Check Environment & Import Public Keys #
##################################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

shasum --version 1>/dev/null || exit
gpg --version 1>/dev/null || exit

wget https://downloads.apache.org/incubator/hugegraph/KEYS || exit
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
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

for i in *.tar.gz; do
  echo "$i"
  shasum -a 512 --check "$i".sha512 || exit
  eval gpg "${GPG_OPT}" --verify "$i".asc "$i" || exit
done

####################################
# Step 4: Validate Source Packages #
####################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

ls -lh ./*.tar.gz
for i in *src.tar.gz; do
  echo "$i"

  # 4.1: check the directory name include "incubating"
  if [[ ! "$i" =~ "incubating" ]]; then
    echo "The package name $i should include incubating" && exit 1
  fi

  tar xzvf "$i" || exit
  pushd "$(basename "$i" .tar.gz)" || exit
  echo "Start to check the package content: $(basename "$i" .tar.gz)"

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

  # 4.3: ensure doesn't contains *GPL/BCL/JSR-275/RSAL/QPL/SSPL/CPOL/NPL1.*/CC-BY
  #      dependency in LICENSE and NOTICE file
  COUNT=$(grep -E "GPL|BCL|JSR-275|RSAL|QPL|SSPL|CPOL|NPL1|CC-BY" LICENSE NOTICE | wc -l)
  if [[ $COUNT -ne 0 ]]; then
     grep -E "GPL|BCL|JSR-275|RSAL|QPL|SSPL|CPOL|NPL1.0|CC-BY" LICENSE NOTICE
     echo "The package $i shouldn't include GPL* invalid dependency, but get $COUNT" && exit 1
  fi

  # 4.4: ensure doesn't contains empty directory or file
  find . -type d -empty | while read -r EMPTY_DIR; do
    find . -type d -empty
    echo "The package $i shouldn't include empty directory: $EMPTY_DIR is empty" && exit 1
  done
  find . -type f -empty | while read -r EMPTY_FILE; do
    find . -type f -empty
    echo "The package $i shouldn't include empty file: $EMPTY_FILE is empty" && exit 1
  done

  # 4.5: ensure any file should less than 800kb
  find . -type f -size +800k | while read -r FILE; do
    find . -type f -size +800k
    echo "The package $i shouldn't include file larger than 800kb: $FILE is larger than 800kb" && exit 1
  done

  # 4.6: ensure all binary files are documented in LICENSE
  find . -type f | perl -lne 'print if -B' | while read -r BINARY_FILE; do
    FILE_NAME=$(basename "$BINARY_FILE")
    if grep -q "$FILE_NAME" LICENSE; then
      echo "Binary file $BINARY_FILE is documented in LICENSE, please check manually"
    else
      echo "Error: Binary file $BINARY_FILE is not documented in LICENSE" && exit 1
    fi
  done

  # 4.7: test compile the packages
  if [[ $JAVA_VERSION == 8 && "$i" =~ "computer" ]]; then
    echo "skip computer module in java8"
    popd || exit
    continue
  fi
  mvn package -DskipTests -ntp -e || exit
  ls -lh

  popd || exit
done

###########################################
# Step 5: Run Compiled Packages In Server #
###########################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

ls -lh
pushd ./*hugegraph-incubating*src/hugegraph-server/*hugegraph*"${RELEASE_VERSION}" || exit
bin/init-store.sh || exit
sleep 3
bin/start-hugegraph.sh || exit
popd || exit

#######################################################################
# Step 6: Run Compiled Packages In ToolChain (Loader & Tool & Hubble) #
#######################################################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

pushd ./*toolchain*src || exit
ls -lh
pushd ./*toolchain*"${RELEASE_VERSION}" || exit
ls -lh

# 6.1: load some data first
echo "test loader"
pushd ./*loader*"${RELEASE_VERSION}" || exit
bin/hugegraph-loader.sh -f ./example/file/struct.json -s ./example/file/schema.groovy \
  -g hugegraph || exit
popd || exit

# 6.2: try some gremlin query & api in tool
echo "test tool"
pushd ./*tool*"${RELEASE_VERSION}" || exit
bin/hugegraph gremlin-execute --script 'g.V().count()' || exit
bin/hugegraph task-list || exit
bin/hugegraph backup -t all --directory ./backup-test || exit
popd || exit

# 6.3: start hubble and connect to server
echo "test hubble"
pushd ./*hubble*"${RELEASE_VERSION}" || exit
# TODO: add hubble doc & test it
cat conf/hugegraph-hubble.properties
bin/start-hubble.sh || exit
bin/stop-hubble.sh || exit
popd || exit

popd || exit
popd || exit
# stop server
pushd ./*hugegraph-incubating*src/hugegraph-server/*hugegraph*"${RELEASE_VERSION}" || exit
bin/stop-hugegraph.sh || exit
popd || exit

# clear source packages
rm -rf ./*src*
ls -lh

####################################
# Step 7: Validate Binary Packages #
####################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

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

  tar xzvf "$i" || exit
  pushd "$(basename "$i" .tar.gz)" || exit
  ls -lh
  echo "Start to check the package content: $(basename "$i" .tar.gz)"

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

  # 7.3: ensure doesn't contains *GPL/BCL/JSR-275/RSAL/QPL/SSPL/CPOL/NPL1.*/CC-BY
  #      dependency in LICENSE/NOTICE and licenses/* files
  COUNT=$(grep -r -E "GPL|BCL|JSR-275|RSAL|QPL|SSPL|CPOL|NPL1|CC-BY" LICENSE NOTICE licenses | wc -l)
  if [[ $COUNT -ne 0 ]]; then
    grep -r -E "GPL|BCL|JSR-275|RSAL|QPL|SSPL|CPQL|NPL1|CC-BY" LICENSE NOTICE licenses
    echo "The package $i shouldn't include GPL* invalid dependency, but get $COUNT" && exit 1
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

  popd || exit
done

# TODO: skip the following steps by comparing the artifacts built from source packages with binary packages
#########################################
# Step 8: Run Binary Packages In Server #
#########################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

pushd ./*hugegraph-incubating*"${RELEASE_VERSION}" || exit
bin/init-store.sh || exit
sleep 3
bin/start-hugegraph.sh || exit
popd || exit

#####################################################################
# Step 9: Run Binary Packages In ToolChain (Loader & Tool & Hubble) #
#####################################################################
cd "$WORK_DIR"/dist/"$RELEASE_VERSION" || exit

pushd ./*toolchain*"${RELEASE_VERSION}" || exit
ls -lh

# 9.1: load some data first
echo "test loader"
pushd ./*loader*"${RELEASE_VERSION}" || exit
bin/hugegraph-loader.sh -f ./example/file/struct.json -s ./example/file/schema.groovy \
  -g hugegraph || exit
popd || exit

# 9.2: try some gremlin query & api in tool
echo "test tool"
pushd ./*tool*"${RELEASE_VERSION}" || exit
bin/hugegraph gremlin-execute --script 'g.V().count()' || exit
bin/hugegraph task-list || exit
bin/hugegraph backup -t all --directory ./backup-test || exit
popd || exit

# 9.3: start hubble and connect to server
echo "test hubble"
pushd ./*hubble*"${RELEASE_VERSION}" || exit
# TODO: add hubble doc & test it
cat conf/hugegraph-hubble.properties
bin/start-hubble.sh || exit
bin/stop-hubble.sh || exit
popd || exit

popd || exit
# stop server
pushd ./*hugegraph-incubating*"${RELEASE_VERSION}" || exit
bin/stop-hugegraph.sh || exit
popd || exit

echo "Finish validate, please check all steps manually again!"
