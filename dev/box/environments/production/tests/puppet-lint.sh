#!/bin/bash
set -euo pipefail

# allow lines longer then 80 characters
# code should be clean of warnings

puppet-lint modules \
--no-140chars-check
