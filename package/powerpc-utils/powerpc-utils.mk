################################################################################
#
# powerpc-utils
#
################################################################################

POWERPC_UTILS_VERSION = v1.4
POWERPC_UTILS_SITE = git://git.code.sf.net/p/powerpc-utils/powerpc-utils
POWERPC_UTILS_AUTORECONF = YES
POWERPC_UTILS_DEPENDENCIES = zlib
POWERPC_UTILS_LICENSE = Common Public License Version 1.0
POWERPC_UTILS_LICENSE_FILES = COPYRIGHT

POWERPC_UTILS_CONF_OPT = --without-librtas

$(eval $(autotools-package))
