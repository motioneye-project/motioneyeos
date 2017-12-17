################################################################################
#
# nodm
#
################################################################################

NODM_VERSION = 0.12-1
NODM_SITE = $(call github,spanezz,nodm,debian/$(NODM_VERSION))
NODM_LICENSE = GPLv2+
NODM_LICENSE_FILES = COPYING
NODM_AUTORECONF = YES

NODM_DEPENDENCIES = xlib_libX11 linux-pam

# help2man doesn't work when cross compiling
define NODM_DISABLE_HELP2MAN
	$(SED) 's/help2man/true/' $(@D)/Makefile.am
endef

NODM_POST_PATCH_HOOKS += NODM_DISABLE_HELP2MAN

define NODM_INSTALL_PAM
	$(INSTALL) -D -m 0644 package/nodm/nodm.pam \
		$(TARGET_DIR)/etc/pam.d/nodm
endef

NODM_POST_INSTALL_TARGET_HOOKS += NODM_INSTALL_PAM

define NODM_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/nodm/S90nodm \
		$(TARGET_DIR)/etc/init.d/S90nodm
endef

$(eval $(autotools-package))
