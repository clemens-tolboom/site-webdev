#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

CEU_CMD=\
  dart $CEU_REPO/bin/code_excerpt_updater.dart \
    --fragment-dir-path tmp/_fragments \
    --indentation 2 \
    --write-in-place \
    src/angular/
LOG=$($CEU_CMD)
CHECK_EXIT_CODE=0

if echo "$LOG" | grep '0 out of' | wc -l > /dev/null; then
  CHECK_EXIT_CODE=1
fi
exit $CHECK_EXIT_CODE