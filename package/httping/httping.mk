################################################################################
#
# httping
#
################################################################################

HTTPING_VERSION = 2.3.4
HTTPING_SOURCE = httping-$(HTTPING_VERSION).tgz
HTTPING_SITE = http://www.vanheusden.com/httping
HTTPING_LICENSE = GPLv2
HTTPING_LICENSE_FILES = license.txt
HTTPING_LDFLAGS = $(if $(BR2_NEEDS_GETTEXT),-lintl) $(TARGET_LDFLAGS)
HTTPING_DEPENDENCIES = host-gettext \
	$(if $(BR2_NEEDS_GETTEXT),gettext) \
	$(if $(BR2_PACKAGE_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_FFTW),fftw)
HTTPING_MAKE_OPT = $(TARGET_CONFIGURE_OPTS) \
	FW=$(if $(BR2_PACKAGE_FFTW),yes,no) \
	NC=no \
	SSL=$(if $(BR2_PACKAGE_OPENSSL),yes,no) \
	TFO=$(if $(BR2_PACKAGE_HTTPING_TFO),yes,no)

define HTTPING_BUILD_CMDS
	$(HTTPING_MAKE_OPT) LDFLAGS="$(HTTPING_LDFLAGS)" \
		$(MAKE) DEBUG=no -C $(@D)
endef

define HTTPING_INSTALL_TARGET_CMDS
	$(HTTPING_MAKE_OPT) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
