################################################################################
#
# network-manager-openvpn
#
################################################################################

NETWORK_MANAGER_OPENVPN_VERSION_MAJOR = 1.8
NETWORK_MANAGER_OPENVPN_VERSION = $(NETWORK_MANAGER_OPENVPN_VERSION_MAJOR).10
NETWORK_MANAGER_OPENVPN_SOURCE = NetworkManager-openvpn-$(NETWORK_MANAGER_OPENVPN_VERSION).tar.xz
NETWORK_MANAGER_OPENVPN_SITE = https://download.gnome.org/sources/NetworkManager-openvpn/$(NETWORK_MANAGER_OPENVPN_VERSION_MAJOR)
NETWORK_MANAGER_OPENVPN_DEPENDENCIES = network-manager openvpn
NETWORK_MANAGER_OPENVPN_LICENSE = GPL-2.0+
NETWORK_MANAGER_OPENVPN_LICENSE_FILES = COPYING

NETWORK_MANAGER_OPENVPN_CONF_OPTS = \
	--without-gnome

define NETWORK_MANAGER_OPENVPN_USERS
	nm-openvpn -1 nm-openvpn -1 * - - - Openvpn user
endef

$(eval $(autotools-package))
