#!/bin/bash
set -euo pipefail

find environments/production/modules -type f -name "*.pp" | xargs puppet parser validate
