################################################################################
#
# mpd-mpc
#
################################################################################

MPD_MPC_VERSION_MAJOR = 0
MPD_MPC_VERSION = $(MPD_MPC_VERSION_MAJOR).28
MPD_MPC_SITE = http://www.musicpd.org/download/mpc/$(MPD_MPC_VERSION_MAJOR)
MPD_MPC_SOURCE = mpc-$(MPD_MPC_VERSION).tar.xz
MPD_MPC_LICENSE = GPL-2.0+
MPD_MPC_LICENSE_FILES = COPYING
MPD_MPC_DEPENDENCIES = host-pkgconf libmpdclient
MPD_MPC_CONF_ENV = ac_cv_prog_cc_c99='-std=c99'

$(eval $(autotools-package))
