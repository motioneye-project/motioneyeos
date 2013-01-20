#############################################################
#
# httping
#
#############################################################

HTTPING_VERSION = 1.5.7
HTTPING_SOURCE = httping-$(HTTPING_VERSION).tgz
HTTPING_SITE = http://www.vanheusden.com/httping
HTTPING_LICENSE = GPLv2
HTTPING_LICENSE_FILES = license.txt
HTTPING_DEPENDENCIES = $(if $(BR2_PACKAGE_OPENSSL),openssl)
HTTPING_MAKE_OPT = $(TARGET_CONFIGURE_OPTS) \
	SSL=$(if $(BR2_PACKAGE_OPENSSL),yes,no) \
	TFO=$(if $(BR2_PACKAGE_HTTPING_TFO),yes,no)

define HTTPING_BUILD_CMDS
	$(HTTPING_MAKE_OPT) $(MAKE) OFLAGS= DEBUG=no -C $(@D)
endef

define HTTPING_INSTALL_TARGET_CMDS
	$(HTTPING_MAKE_OPT) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

define HTTPING_CLEAN_CMDS
       $(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
