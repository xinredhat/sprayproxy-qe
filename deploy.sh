#!/usr/bin/env bash

#quit if exit status of any cmd is a non-zero value
set -euo pipefail
set -x

SCRIPT_DIR="$(
  cd "$(dirname "$0")" >/dev/null
  pwd
)"

NAMESPACE="sprayproxy"

precheck_params() {
  WEBHOOK_SECRET="${WEBHOOK_SECRET:-}"
  if [ -z "$WEBHOOK_SECRET" ]; then
         echo "ERROR: missed WEBHOOK_SECRET"
         exit 1
  fi

  PAC_GITHUB_APP_PRIVATE_KEY="${PAC_GITHUB_APP_PRIVATE_KEY:-}"
  if [[ -z "$PAC_GITHUB_APP_PRIVATE_KEY" ]]; then
         echo "ERROR: missed PAC_GITHUB_APP_PRIVATE_KEY"
         exit 1
  fi
}

deploy() {
  kubectl apply -k "$SCRIPT_DIR"/config
  # Add pipelines-as-code-secret
  kubectl -n "$NAMESPACE" create secret generic pipelines-as-code-secret \
         --from-literal github-private-key="$(echo "$PAC_GITHUB_APP_PRIVATE_KEY" | base64 -d)" \
         --from-literal github-application-id="$PAC_GITHUB_APP_ID" \
         --from-literal webhook.secret="$WEBHOOK_SECRET"
}

main() {
  precheck_params
  deploy
}

if [ "${BASH_SOURCE[0]}" == "$0" ]; then
  main "$@"
fi
