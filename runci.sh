#!/bin/bash
set -euo pipefail

ruff check --select=F,E,W,I --ignore=E501 smtpsmug
