#!/bin/sh

bin=$(toolchain/dependencies/check-host-lzma.sh)
if [ "x$bin" = "x" ] ; then
  echo build-lzma-host-binary
else
  echo use-lzma-host-binary
fi

