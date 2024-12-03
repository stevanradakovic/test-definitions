#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2024 Linaro Ltd.
set -x
. ../../lib/sh-test-lib

# source the secrets file to get the gitlab_token env var
. ../../../../../../secrets > /dev/null 2>&1

# install dependencies
install_deps "bzip2 git curl libxtst6 libgtk-3-0 libx11-xcb-dev libdbus-glib-1-2 libxt6 libpci-dev python3-pip wget" "$SKIP_INSTALL"

GECKODRIVER_VERSION=$(wget -qO- https://api.github.com/repos/mozilla/geckodriver/releases/latest | grep "tag_name" | sed -E 's/.*"([^"]+)".*/\1/')
echo $GECKODRIVER_VERSION
wget -qO /tmp/geckodriver.tar.gz "https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux-aarch64.tar.gz"
tar -xzf /tmp/geckodriver.tar.gz -C /usr/local/bin/
rm /tmp/geckodriver.tar.gz \


# install spire package
wget https://github.com/Linaro/SPIRE-CLI-S-/releases/download/0.2.0-alpha%2B006/staging-spire_0.2.0-alpha+006_linux_amd64.deb
dpkg -i staging-spire_0.2.0-alpha+006_linux_amd64.deb

# clone baklava-integration repo and install required pip pkgs
get_test_program "https://gitlab-ci-token:${GITLAB_TOKEN}@gitlab.com/LinaroLtd/lava/appliance/baklava-integration.git" "baklava-integration" "main"
pip3 install -r requirements.txt

export SPIRE_PAT_TOKEN LAVA_TOKEN LAVA_PASSWORD

# run tests
robot --pythonpath . --variable remote:"$IS_REMOTE" --outputdir=.. test/
exit 0
