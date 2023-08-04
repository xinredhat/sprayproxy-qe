#!/usr/bin/env bash

#quit if exit status of any cmd is a non-zero value
set -euo pipefail


# get pac route url
pac_route_url=$(get route/pipelines-as-code-controller -n openshift-pipelines )