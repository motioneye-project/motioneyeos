#!/bin/sh

# prevent shift error
[ $# -lt 2 ] && exit 1

major_min="${1%.*}"
minor_min="${1#*.}"

shift

for candidate; do

    # Try to locate the candidate. Discard it if not located.
    cmake=`which "${candidate}" 2>/dev/null`
    [ -n "${cmake}" ] || continue

    # Extract version X.Y from versions in the form X.Y or X.Y.Z
    # with X, Y and Z numbers with one or more digits each, e.g.
    #   3.2     -> 3.2
    #   3.2.3   -> 3.2
    #   3.2.42  -> 3.2
    #   3.10    -> 3.10
    #   3.10.4  -> 3.10
    #   3.10.42 -> 3.10
    # Discard the candidate if no version can be obtained
    version="$(${cmake} --version \
               |sed -r -e '/.* ([[:digit:]]+\.[[:digit:]]+).*$/!d;' \
                       -e 's//\1/'
              )"
    [ -n "${version}" ] || continue

    major="${version%.*}"
    minor="${version#*.}"

    if [ ${major} -gt ${major_min} ]; then
        echo "${cmake}"
        exit
    elif [ ${major} -eq ${major_min} -a ${minor} -ge ${minor_min} ]; then
        echo "${cmake}"
        exit
    fi
done

# echo nothing: no suitable cmake found
exit 1
