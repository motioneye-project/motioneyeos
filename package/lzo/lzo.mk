################################################################################
#
# lzo
#
################################################################################

LZO_VERSION = 2.08
LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_LICENSE = GPLv2+
LZO_LICENSE_FILES = COPYING
LZO_INSTALL_STAGING = YES
# Our libtool patch does not apply to bundled ltmain.sh since it's too new.
# Run autoreconf to regenerate ltmain.sh.
LZO_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
