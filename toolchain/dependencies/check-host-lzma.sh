#!/bin/sh

ok=""

for bin in /usr/bin/lzma $LZMA
do
# TODO: add check for proper functionality here..
  $bin --version > /dev/null 2>&1 && ok="$bin"
  if test "x$ok" != "x" ; then
    break
  fi
done
echo "$ok"
