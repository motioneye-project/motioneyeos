#!/bin/sh

candidate="${1}"
version_min="${2}"

major_min="${version_min%.*}"
minor_min="${version_min#*.}"

cmake=`which ${candidate}`
if [ ! -x "${cmake}" ]; then
    # echo nothing: no suitable cmake found
    exit 1
fi

# Extract version X.Y from versions in the form X.Y or X.Y.Z
# with X, Y and Z numbers with one or more digits each, e.g.
#   3.2     -> 3.2
#   3.2.3   -> 3.2
#   3.2.42  -> 3.2
#   3.10    -> 3.10
#   3.10.4  -> 3.10
#   3.10.42 -> 3.10
version="$(${cmake} --version \
           |sed -r -e '/.* ([[:digit:]]+\.[[:digit:]]+).*$/!d;' \
                   -e 's//\1/'
          )"
major="${version%.*}"
minor="${version#*.}"

if [ ${major} -gt ${major_min} ]; then
    echo "${cmake}"
else
    if [ ${major} -eq ${major_min} -a ${minor} -ge ${minor_min} ]; then
        echo "${cmake}"
    else
        # echo nothing: no suitable cmake found
        exit 1
    fi
fi
