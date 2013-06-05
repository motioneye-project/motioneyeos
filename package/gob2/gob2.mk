################################################################################
#
# gob2
#
################################################################################

GOB2_VERSION = 2.0.18
GOB2_SITE = http://ftp.5z.com/pub/gob
GOB2_DEPENDENCIES = libglib2 flex bison host-pkgconf host-flex
HOST_GOB2_DEPENDENCIES = host-bison host-flex host-libglib2

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# gob2 for the host
GOB2_HOST_BINARY = $(HOST_DIR)/usr/bin/gob2
