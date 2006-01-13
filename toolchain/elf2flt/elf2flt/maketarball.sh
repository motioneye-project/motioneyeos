#!/bin/bash

cvs_stamp=$(cut -d/ -f4 CVS/Entries | sort | tail -n 1)
stamp=$(date +%Y%m%d --date="${cvs_stamp}")

p="elf2flt-${stamp}"
rm -f elf2flt-*.tar.bz2
mkdir ../${p}
cp -r * ../${p}/ || exit 1
tar jcf ${p}.tar.bz2 --exclude .svn -C .. ${p}
rm -r ../${p} || exit 1
du -b ${p}.tar.bz2
