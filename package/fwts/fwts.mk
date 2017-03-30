################################################################################
#
# fwts
#
################################################################################

FWTS_VERSION = V16.11.00
FWTS_SITE = http://fwts.ubuntu.com/release
FWTS_STRIP_COMPONENTS = 0
FWTS_LICENSE = GPL-2.0, LGPL-2.1, Custom
FWTS_LICENSE_FILES = debian/copyright
FWTS_AUTORECONF = YES
FWTS_DEPENDENCIES = host-bison host-flex host-pkgconf json-c libglib2 \
	$(if $(BR2_PACKAGE_DTC),dtc)

$(eval $(autotools-package))
