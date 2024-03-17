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

# Download hugegraph-server and hugegraph-toolcahain, then start them:
# hugegraph-server and hugegraph-hubble

set -e

RELEASE_VERSION=$1 # like 1.2.0
RELEASE_VERSION=${RELEASE_VERSION:?"Please input the release version, like 1.2.0"}

DOWNLOAD_URL_PREFIX="https://downloads.apache.org/incubator/hugegraph"
SERVER_TAR="apache-hugegraph-incubating-${RELEASE_VERSION}.tar.gz"
TOOLCHAIN_TAR="apache-hugegraph-toolchain-incubating-${RELEASE_VERSION}.tar.gz"

echo "download hugegraph tars from $DOWNLOAD_URL_PREFIX..."
if [[ ! -f "${SERVER_TAR}" ]]; then
  wget "${DOWNLOAD_URL_PREFIX}/${RELEASE_VERSION}/${SERVER_TAR}"
  tar -xzvf "${SERVER_TAR}"
fi
if [[ ! -f "${TOOLCHAIN_TAR}" ]]; then
  wget "${DOWNLOAD_URL_PREFIX}/${RELEASE_VERSION}/${TOOLCHAIN_TAR}"
  tar -xzvf ${TOOLCHAIN_TAR}
fi

echo "start hugegraph-server..."
cd ./*hugegraph-incubating*${RELEASE_VERSION}
bin/init-store.sh
sleep 3
bin/start-hugegraph.sh
cd ..

echo "start hugegraph-hubble..."
cd ./*toolchain*${RELEASE_VERSION}/*hubble*${RELEASE_VERSION}
bin/start-hubble.sh
