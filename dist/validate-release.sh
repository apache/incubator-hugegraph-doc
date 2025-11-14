#!/usr/bin/env bash
#
# This script is used to validate the release package, including:
# 1. Check the release package name & content
# 2. Check the release package sha512 & gpg signature
# 3. Compile the source package & run server & toolchain
# 4. Run server & toolchain in binary package
#
# Usage:
#   1. Validate from Apache SVN (default):
#      ./validate-release.sh <version> <user> [local-path] [java-version]
#      Example: ./validate-release.sh 1.7.0 pengjunzhi
#      Example: ./validate-release.sh 1.7.0 pengjunzhi "" 11
#
#   2. Validate from local directory:
#      ./validate-release.sh <version> <user> <local-path> [java-version]
#      Example: ./validate-release.sh 1.7.0 pengjunzhi /path/to/dist
#      Example: ./validate-release.sh 1.7.0 pengjunzhi /path/to/dist 11

# exit when any error occurs
set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# release version (input by committer)
RELEASE_VERSION=$1 # like 1.7.0
USER=$2
LOCAL_DIST_PATH=$3 # optional: local directory path containing release files
JAVA_VERSION=${4:-11} # optional: default to 11

# this URL is only valid during the release process
SVN_URL_PREFIX="https://dist.apache.org/repos/dist/dev/incubator/hugegraph"

# git release branch (check it carefully)
#GIT_BRANCH="release-${RELEASE_VERSION}"

RELEASE_VERSION=${RELEASE_VERSION:?"Please input the release version, like 1.7.0"}
USER=${USER:?"Please input the user name"}
WORK_DIR=$(
  cd "$(dirname "$0")"
  pwd
)

cd "${WORK_DIR}"
echo "Current work dir: $(pwd)"

####################################################
# Step 1: Prepare Release Files (SVN or Local)    #
####################################################
if [[ -n "${LOCAL_DIST_PATH}" ]]; then
  # Use local directory
  DIST_DIR="${LOCAL_DIST_PATH}"
  echo "Using local directory: ${DIST_DIR}"

  # Validate local directory exists
  if [[ ! -d "${DIST_DIR}" ]]; then
    echo -e "${RED}Error: Directory ${DIST_DIR} does not exist${NC}"
    exit 1
  fi

  echo "Contents of ${DIST_DIR}:"
  ls -lh "${DIST_DIR}"
else
  # Download from SVN
  DIST_DIR="${WORK_DIR}/dist/${RELEASE_VERSION}"
  echo "Downloading from SVN to: ${DIST_DIR}"

  rm -rf "${DIST_DIR}"
  mkdir -p "${DIST_DIR}"
  cd "${DIST_DIR}"
  svn co "${SVN_URL_PREFIX}/${RELEASE_VERSION}" .
fi

cd "${DIST_DIR}"
echo "Release files directory: ${DIST_DIR}"

##################################################
# Step 2: Check Environment & Import Public Keys #
##################################################
shasum --version 1>/dev/null
gpg --version 1>/dev/null

# Check Java version
echo "Checking Java version..."
if ! command -v java &> /dev/null; then
  echo -e "${RED}Error: Java is not installed or not in PATH${NC}"
  exit 1
fi

CURRENT_JAVA_VERSION=$(java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}' | awk -F '.' '{print $1}')
echo "Current Java version: $CURRENT_JAVA_VERSION (Required: ${JAVA_VERSION})"

if [[ "$CURRENT_JAVA_VERSION" != "$JAVA_VERSION" ]]; then
  echo -e "${RED}Error: Java version mismatch!${NC}"
  echo -e "${RED}  Current: Java $CURRENT_JAVA_VERSION${NC}"
  echo -e "${RED}  Required: Java ${JAVA_VERSION}${NC}"
  echo -e "${RED}  Please switch to Java ${JAVA_VERSION} before running this script${NC}"
  exit 1
fi

echo -e "${GREEN}Java version check passed: Java $CURRENT_JAVA_VERSION${NC}"

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
cd "${DIST_DIR}"

for i in *.tar.gz; do
  echo "$i"
  shasum -a 512 --check "$i".sha512
  eval gpg "${GPG_OPT}" --verify "$i".asc "$i"
done

####################################
# Step 4: Validate Source Packages #
####################################
cd "${DIST_DIR}"

CATEGORY_X="\bGPL|\bLGPL|Sleepycat License|BSD-4-Clause|\bBCL\b|JSR-275|Amazon Software License|\bRSAL\b|\bQPL\b|\bSSPL|\bCPOL|\bNPL1|Creative Commons Non-Commercial|JSON\.org"
CATEGORY_B="\bCDDL1|\bCPL|\bEPL|\bIPL|\bMPL|\bSPL|OSL-3.0|UnRAR License|Erlang Public License|\bOFL\b|Ubuntu Font License Version 1.0|IPA Font License Agreement v1.0|EPL2.0|CC-BY"
ls -lh ./*.tar.gz
for i in *src.tar.gz; do
  echo "$i"

  # 4.1: check the directory name include "incubating"
  if [[ ! "$i" =~ "incubating" ]]; then
    echo -e "${RED}The package name $i should include incubating${NC}" && exit 1
  fi

  MODULE_DIR=$(basename "$i" .tar.gz)
  rm -rf ${MODULE_DIR}
  tar -xzvf "$i"
  pushd ${MODULE_DIR}
  echo "Start to check the package content: ${MODULE_DIR}"

  # 4.2: check the directory include "NOTICE" and "LICENSE" file and "DISCLAIMER" file
  if [[ ! -f "LICENSE" ]]; then
    echo -e "${RED}The package $i should include LICENSE file${NC}" && exit 1
  fi
  if [[ ! -f "NOTICE" ]]; then
    echo -e "${RED}The package $i should include NOTICE file${NC}" && exit 1
  fi
  if [[ ! -f "DISCLAIMER" ]]; then
    echo -e "${RED}The package $i should include DISCLAIMER file${NC}" && exit 1
  fi

  # 4.3: ensure doesn't contains ASF CATEGORY X License dependencies in LICENSE and NOTICE files
  COUNT=$(grep -E "$CATEGORY_X" LICENSE NOTICE | wc -l)
  if [[ $COUNT -ne 0 ]]; then
     grep -E "$CATEGORY_X" LICENSE NOTICE
     echo -e "${RED}The package $i shouldn't include invalid ASF category X dependencies, but get $COUNT${NC}" && exit 1
  fi

  # 4.4: ensure doesn't contains ASF CATEGORY B License dependencies in LICENSE and NOTICE files
  COUNT=$(grep -E "$CATEGORY_B" LICENSE NOTICE | wc -l)
  if [[ $COUNT -ne 0 ]]; then
     grep -E "$CATEGORY_B" LICENSE NOTICE
     echo -e "${RED}The package $i shouldn't include invalid ASF category B dependencies, but get $COUNT${NC}" && exit 1
  fi

  # 4.5: ensure doesn't contains empty directory or file
  find . -type d -empty | while read -r EMPTY_DIR; do
    find . -type d -empty
    echo -e "${RED}The package $i shouldn't include empty directory: $EMPTY_DIR is empty${NC}" && exit 1
  done
  find . -type f -empty | while read -r EMPTY_FILE; do
    find . -type f -empty
    echo -e "${RED}The package $i shouldn't include empty file: $EMPTY_FILE is empty${NC}" && exit 1
  done

  # 4.6: ensure any file should less than 800kb
  find . -type f -size +800k | while read -r FILE; do
    find . -type f -size +800k
    echo -e "${RED}The package $i shouldn't include file larger than 800kb: $FILE is larger than 800kb${NC}" && exit 1
  done

  # 4.7: ensure all binary files are documented in LICENSE
  find . -type f | perl -lne 'print if -B' | while read -r BINARY_FILE; do
    FILE_NAME=$(basename "$BINARY_FILE")
    if grep -q "$FILE_NAME" LICENSE; then
      echo -e "${YELLOW}Binary file $BINARY_FILE is documented in LICENSE, please check manually${NC}"
    else
      echo -e "${RED}Error: Binary file $BINARY_FILE is not documented in LICENSE${NC}" && exit 1
    fi
  done

  # 4.8: test compile the packages
  if [[ "$i" =~ 'hugegraph-ai' ]]; then
    echo "Skip compile $i module in all versions"
  elif [[ "$i" =~ "hugegraph-computer" ]]; then
    cd computer
    mvn package -DskipTests -Papache-release -ntp -e
  else
    # TODO: consider using commands that are entirely consistent with building binary packages
    mvn package -DskipTests -Papache-release -ntp -e
    ls -lh
  fi
  popd
done

###########################################
# Step 5: Run Compiled Packages of Server #
###########################################
cd "${DIST_DIR}"

ls -lh
pushd ./*hugegraph-incubating*src/hugegraph-server/*hugegraph*"${RELEASE_VERSION}"
bin/init-store.sh
sleep 3
bin/start-hugegraph.sh
popd

#######################################################################
# Step 6: Run Compiled Packages of ToolChain (Loader & Tool & Hubble) #
#######################################################################
cd "${DIST_DIR}"

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
cd "${DIST_DIR}"

for i in *.tar.gz; do
  if [[ "$i" == *-src.tar.gz ]]; then
    # skip source packages
    continue
  fi

  echo "$i"

  # 7.1: check the directory name include "incubating"
  if [[ ! "$i" =~ "incubating" ]]; then
    echo -e "${RED}The package name $i should include incubating${NC}" && exit 1
  fi

  MODULE_DIR=$(basename "$i" .tar.gz)
  rm -rf ${MODULE_DIR}
  tar -xzvf "$i"
  pushd ${MODULE_DIR}
  ls -lh
  echo "Start to check the package content: ${MODULE_DIR}"

  # 7.2: check root dir include "NOTICE"/"LICENSE"/"DISCLAIMER" files & "licenses" dir
  if [[ ! -f "LICENSE" ]]; then
    echo -e "${RED}The package $i should include LICENSE file${NC}" && exit 1
  fi
  if [[ ! -f "NOTICE" ]]; then
    echo -e "${RED}The package $i should include NOTICE file${NC}" && exit 1
  fi
  if [[ ! -f "DISCLAIMER" ]]; then
    echo -e "${RED}The package $i should include DISCLAIMER file${NC}" && exit 1
  fi
  if [[ ! -d "licenses" ]]; then
    echo -e "${RED}The package $i should include licenses dir${NC}" && exit 1
  fi

  # 7.3: ensure doesn't contains ASF CATEGORY X License dependencies in LICENSE/NOTICE and licenses/* files
  COUNT=$(grep -r -E "$CATEGORY_X" LICENSE NOTICE licenses | wc -l)
  if [[ $COUNT -ne 0 ]]; then
    grep -r -E "$CATEGORY_X" LICENSE NOTICE licenses
    echo -e "${RED}The package $i shouldn't include invalid ASF category X dependencies, but get $COUNT${NC}" && exit 1
  fi

  # 7.4: ensure doesn't contains empty directory or file
  find . -type d -empty | while read -r EMPTY_DIR; do
    find . -type d -empty
    echo -e "${RED}The package $i shouldn't include empty directory: $EMPTY_DIR is empty${NC}" && exit 1
  done
  find . -type f -empty | while read -r EMPTY_FILE; do
    find . -type f -empty
    echo -e "${RED}The package $i shouldn't include empty file: $EMPTY_FILE is empty${NC}" && exit 1
  done

  popd
done

# TODO: skip the following steps by comparing the artifacts built from source packages with binary packages
#########################################
# Step 8: Run Binary Packages of Server #
#########################################
cd "${DIST_DIR}"

# TODO: run pd & store
pushd ./*hugegraph-incubating*"${RELEASE_VERSION}"/*hugegraph-server-incubating*"${RELEASE_VERSION}"
bin/init-store.sh
sleep 3
bin/start-hugegraph.sh
popd

#####################################################################
# Step 9: Run Binary Packages of ToolChain (Loader & Tool & Hubble) #
#####################################################################
cd "${DIST_DIR}"

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
pushd ./*hugegraph-incubating*"${RELEASE_VERSION}"/*hugegraph-server-incubating*"${RELEASE_VERSION}"
bin/stop-hugegraph.sh
popd

echo -e "${GREEN}Finish validate, please check all steps manually again!${NC}"
