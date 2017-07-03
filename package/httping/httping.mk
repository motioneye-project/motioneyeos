################################################################################
#
# httping
#
################################################################################

HTTPING_VERSION = 2.5
HTTPING_SOURCE = httping-$(HTTPING_VERSION).tgz
HTTPING_SITE = http://www.vanheusden.com/httping
HTTPING_LICENSE = GPL-2.0
HTTPING_LICENSE_FILES = license.txt
HTTPING_LDFLAGS = $(TARGET_LDFLAGS) \
	$(TARGET_NLS_LIBS) \
	$(if $(BR2_PACKAGE_LIBICONV),-liconv)
HTTPING_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	$(if $(BR2_PACKAGE_NCURSES_WCHAR),ncurses) \
	$(if $(BR2_PACKAGE_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_FFTW),fftw)
HTTPING_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) \
	FW=$(if $(BR2_PACKAGE_FFTW),yes,no) \
	NC=$(if $(BR2_PACKAGE_NCURSES_WCHAR),yes,no) \
	SSL=$(if $(BR2_PACKAGE_OPENSSL),yes,no) \
	TFO=$(if $(BR2_PACKAGE_HTTPING_TFO),yes,no)

define HTTPING_BUILD_CMDS
	$(HTTPING_MAKE_OPTS) LDFLAGS="$(HTTPING_LDFLAGS)" \
		$(MAKE) DEBUG=no -C $(@D)
endef

define HTTPING_INSTALL_TARGET_CMDS
	$(HTTPING_MAKE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
