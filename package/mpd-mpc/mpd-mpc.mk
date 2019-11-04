################################################################################
#
# mpd-mpc
#
################################################################################

MPD_MPC_VERSION_MAJOR = 0
MPD_MPC_VERSION = $(MPD_MPC_VERSION_MAJOR).33
MPD_MPC_SITE = http://www.musicpd.org/download/mpc/$(MPD_MPC_VERSION_MAJOR)
MPD_MPC_SOURCE = mpc-$(MPD_MPC_VERSION).tar.xz
MPD_MPC_LICENSE = GPL-2.0+
MPD_MPC_LICENSE_FILES = COPYING
MPD_MPC_DEPENDENCIES = host-pkgconf libmpdclient

$(eval $(meson-package))
