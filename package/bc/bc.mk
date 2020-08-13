################################################################################
#
# bc
#
################################################################################

BC_VERSION = 1.07.1
BC_SITE = http://ftp.gnu.org/gnu/bc
BC_DEPENDENCIES = host-flex
BC_LICENSE = GPL-2.0+, LGPL-2.1+
BC_LICENSE_FILES = COPYING COPYING.LIB
BC_CONF_ENV = MAKEINFO=true

# 0001-bc-use-MAKEINFO-variable-for-docs.patch and 0004-no-gen-libmath.patch
# are patching doc/Makefile.am and Makefile.am respectively
BC_AUTORECONF = YES

$(eval $(autotools-package))
