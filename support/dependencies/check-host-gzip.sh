#!/bin/sh

candidate="$1" # ignored

gzip="$(which gzip)"
if [ ! -x "${gzip}" ]; then
    # echo nothing: no suitable gzip found
    exit 1
fi

# gzip displays its version string on stdout
# pigz displays its version string on stderr
version="$("${gzip}" --version 2>&1)"
case "${version}" in
  (*pigz*)
    # echo nothing: no suitable gzip found
    exit 1
    ;;
esac

printf "%s" "${gzip}"
