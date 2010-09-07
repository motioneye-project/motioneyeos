#############################################################
#
# tcpdump
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>

TCPDUMP_VERSION:=4.0.0
TCPDUMP_SITE:=http://www.tcpdump.org/release
TCPDUMP_SOURCE:=tcpdump-$(TCPDUMP_VERSION).tar.gz
TCPDUMP_CONF_ENV:=ac_cv_linux_vers=$(firstword $(subst .,$(space),$(firstword $(call qstrip,$(BR2_DEFAULT_KERNEL_HEADERS)))))
TCPDUMP_CONF_OPT:=--without-crypto \
		$(if $(BR2_PACKAGE_TCPDUMP_SMB),--enable-smb,--disable-smb)
TCPDUMP_DEPENDENCIES:=zlib libpcap

$(eval $(call AUTOTARGETS,package,tcpdump))
