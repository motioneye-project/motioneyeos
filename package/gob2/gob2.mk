################################################################################
#
# gob2
#
################################################################################

GOB2_VERSION = 2.0.20
GOB2_SOURCE = gob2-$(GOB2_VERSION).tar.xz
GOB2_SITE = http://ftp.5z.com/pub/gob
GOB2_LICENSE = GPL-2.0+
GOB2_LICENSE_FILES = COPYING COPYING.generated-code
HOST_GOB2_DEPENDENCIES = host-bison host-flex host-libglib2

$(eval $(host-autotools-package))

# gob2 for the host
GOB2_HOST_BINARY = $(HOST_DIR)/bin/gob2
