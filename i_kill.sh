#!/usr/bin/sh
ps -u `id -u` | sed -n '/sed/!s/^I  *\([0-9][0-9]*\).*$/echo "kill \1" \&\& kill -9 \1/p' | sh
