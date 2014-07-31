################################################################################
#
# isl
#
################################################################################

# The latest 0.13 version is not yet compatible with cloog 0.18.2, so
# bumping isl is not possible until a new version of cloog is
# published.
ISL_VERSION = 0.12.2
ISL_SOURCE = isl-$(ISL_VERSION).tar.bz2
ISL_SITE = http://isl.gforge.inria.fr
ISL_LICENSE = MIT
ISL_LICENSE_FILES = LICENSE
ISL_DEPENDENCIES = gmp

# Our libtool patch doesn't apply, and since this package is only
# built for the host, we don't really care about it.
ISL_LIBTOOL_PATCH = NO

$(eval $(host-autotools-package))
