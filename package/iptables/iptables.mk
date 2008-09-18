#############################################################
#
# iptables
#
#############################################################
IPTABLES_VERSION = 1.4.1
IPTABLES_SOURCE = iptables-$(IPTABLES_VERSION).tar.bz2
IPTABLES_SITE = http://ftp.netfilter.org/pub/iptables

IPTABLES_CONF_OPT = --libexecdir=/usr/lib
IPTABLES_INSTALL_TARGET = YES
IPTABLES_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install-strip

IPTABLES_AUTORECONF = YES
IPTABLES_DEPENDENCIES =
IPTABLES_CONFIGURE_OPT = --with-kernel=$(LINUX_HEADERS_DIR)
IPTABLES_MAKE_OPT = GLIB_GENMARSHAL=/usr/bin/glib-genmarshal GLIB_MKENUMS=/usr/bin

$(eval $(call AUTOTARGETS,package,iptables))
