#!/bin/bash
set -euo pipefail

find . -type f -name "*.pp" | xargs puppet parser validate --debug