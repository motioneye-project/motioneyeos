#############################################################
#
# ethtool
#
#############################################################

ETHTOOL_VERSION:=6
ETHTOOL_SOURCE:=ethtool-$(ETHTOOL_VERSION).tar.gz
ETHTOOL_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gkernel/
ETHTOOL_AUTORECONF:=no
ETHTOOL_INSTALL_STAGING:=NO
ETHTOOL_INSTALL_TARGET:=YES
ETHTOOL_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip
ETHTOOL_UNINSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) uninstall

ETHTOOL_DEPENDENCIES:=uclibc

$(eval $(call AUTOTARGETS,package,ethtool))
