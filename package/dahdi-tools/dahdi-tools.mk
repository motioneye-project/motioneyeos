################################################################################
#
# dahdi-tools
#
################################################################################

DAHDI_TOOLS_VERSION = 2.11.1
DAHDI_TOOLS_SITE = http://downloads.asterisk.org/pub/telephony/dahdi-tools/releases

DAHDI_TOOLS_LICENSE = GPLv2, LGPLv2.1
DAHDI_TOOLS_LICENSE_FILES = LICENSE LICENSE.LGPL

DAHDI_TOOLS_DEPENDENCIES = dahdi-linux perl

DAHDI_TOOLS_INSTALL_STAGING = YES
DAHDI_TOOLS_AUTORECONF = YES

# Buildroot globally exports PERL with the value it has on the host, so we need
# to override it with the location where it will be on the target.
DAHDI_TOOLS_CONF_ENV = PERL=/usr/bin/perl

DAHDI_TOOLS_CONF_OPTS = \
	--without-newt \
	--without-usb \
	--without-pcap \
	--without-libusbx \
	--without-libusb \
	--without-selinux \
	--without-ppp \
	--with-perllib=/usr/lib/perl5/$(PERL_VERSION)

$(eval $(autotools-package))
