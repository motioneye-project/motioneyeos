################################################################################
#
# ti-sgx-libgbm
#
################################################################################

# This correpsonds to SDK 06.00.00.07
TI_SGX_LIBGBM_VERSION = c5ddc6a37bb78ac753b317b17d890d1f7338dea6
TI_SGX_LIBGBM_SITE = http://git.ti.com/git/glsdk/libgbm.git
TI_SGX_LIBGBM_SITE_METHOD = git
TI_SGX_LIBGBM_LICENSE = MIT
TI_SGX_LIBGBM_LICENSE_FILES = gbm.h
TI_SGX_LIBGBM_INSTALL_STAGING = YES
TI_SGX_LIBGBM_AUTORECONF = YES

TI_SGX_LIBGBM_DEPENDENCIES = libdrm udev

define TI_SGX_LIBGBM_INSTALL_TARGET_OPTS
	PREFIX=/usr \
	STRIP=/bin/true \
	DESTDIR=$(TARGET_DIR) \
	install
endef

define TI_SGX_LIBGBM_INSTALL_STAGING_OPTS
	PREFIX=/usr \
	STRIP=/bin/true \
	DESTDIR=$(STAGING_DIR) \
	install
endef

$(eval $(autotools-package))
