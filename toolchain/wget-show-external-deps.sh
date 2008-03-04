#!/bin/sh
#
# replacement for wget (see BR2_WGET) which simply shows the file name to be
# downloaded. Used by the external-deps make target.

exec basename ${!#}