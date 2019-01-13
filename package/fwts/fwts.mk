################################################################################
#
# fwts
#
################################################################################

FWTS_VERSION = V18.09.00
FWTS_SITE = http://fwts.ubuntu.com/release
FWTS_STRIP_COMPONENTS = 0
FWTS_LICENSE = GPL-2.0, LGPL-2.1, Custom
FWTS_LICENSE_FILES = debian/copyright
FWTS_AUTORECONF = YES
FWTS_DEPENDENCIES = host-bison host-flex host-pkgconf json-c libglib2 libbsd \
	$(if $(BR2_PACKAGE_BASH_COMPLETION),bash-completion) \
	$(if $(BR2_PACKAGE_DTC),dtc)

ifdef BR2_PACKAGE_FWTS_EFI_RUNTIME_MODULE
FWTS_MODULE_SUBDIRS = efi_runtime
$(eval $(kernel-module))
endif

$(eval $(autotools-package))
