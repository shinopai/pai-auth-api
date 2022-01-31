#!/bin/bash
set -e

rm -f /pai-auth/tmp/pids/server.pid

exec "$@"
