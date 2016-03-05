################################################################################
#
# radvd
#
################################################################################

RADVD_VERSION = 2.11
RADVD_SOURCE = radvd-$(RADVD_VERSION).tar.xz
RADVD_SITE = http://www.litech.org/radvd/dist
RADVD_PATCH = \
	https://github.com/reubenhwk/radvd/commit/1d8973e13d89802eee0b648451e2b97ac65cf9e0.patch
RADVD_DEPENDENCIES = host-bison flex host-flex host-pkgconf
RADVD_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
# We're patching configure.ac/Makefile.am.
RADVD_AUTORECONF = YES
RADVD_LICENSE = BSD-4c-like
RADVD_LICENSE_FILES = COPYRIGHT

define RADVD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/radvd/S50radvd $(TARGET_DIR)/etc/init.d/S50radvd
endef

$(eval $(autotools-package))
