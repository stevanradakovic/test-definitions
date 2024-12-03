#!/bin/sh

. ../../lib/sh-test-lib

gitlab_token=""
# source the secrets file to get the gitlab_token env var
. ../../../../../../secrets > /dev/null 2>&1
install_deps "git curl python3-pip" "$SKIP_INSTALL"

get_test_program "https://gitlab-ci-token:${GITLAB_TOKEN}@gitlab.com/LinaroLtd/lava/appliance/baklava-integration.git" "baklava-integration" "main"
pip3 install -r requirements.txt

robot --pythonpath . --variable remote:"$IS_REMOTE" --outputdir=.. test/
exit 0
