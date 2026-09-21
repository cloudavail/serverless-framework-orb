#!/bin/bash

[ "$ORB_PARAM_MIRROR" = "cn" ] && locale=cn
[ "$ORB_PARAM_MIRROR" = "us" ] && locale=us

# Temporarily pin to github per Serverless recommendation.
# Note that locale-specific mirror features will be mostly unavailable.
# See https://forum.serverless.com/t/serverless-deploy-failing-when-run-from-circleci/20184/14
install_url="https://raw.githubusercontent.com/serverless/serverless/v3/scripts/pkg/install.sh"

# Let Serverless handle mirror selection.
curl -o- -L "${install_url}" | VERSION="$ORB_PARAM_SERVERLESS_VERSION" SLS_GEO_LOCATION="$locale" bash

# shellcheck disable=SC2016
echo 'export PATH=$HOME/.serverless/bin:$PATH' >> "$BASH_ENV"
# shellcheck disable=SC1090
source "$BASH_ENV"
# SERVERLESS_ACCESS_KEY is only required when using the Serverless Dashboard.
if [ -z "$SERVERLESS_ACCESS_KEY" ]; then
  echo "Notice: The environment variable SERVERLESS_ACCESS_KEY is not set.
    This is only required if your service uses the Serverless Dashboard. If it does, create a dashboard
    access key and add it to this project as a project environment variable or via contexts.
    https://serverless.com/framework/docs/dashboard/cicd/running-in-your-own-cicd#configure-environment-variables"
fi
