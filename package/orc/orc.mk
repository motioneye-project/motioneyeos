################################################################################
#
# orc
#
################################################################################

ORC_VERSION = 0.4.31
ORC_SOURCE = orc-$(ORC_VERSION).tar.xz
ORC_SITE = http://gstreamer.freedesktop.org/data/src/orc
ORC_LICENSE = BSD-2-Clause, BSD-3-Clause
ORC_LICENSE_FILES = COPYING
ORC_INSTALL_STAGING = YES
ORC_DEPENDENCIES = host-orc
ORC_CONF_OPTS = \
	-Dbenchmarks=disabled \
	-Dexamples=disabled \
	-Dgtk_doc=disabled \
	-Dorc-test=disabled \
	-Dtests=disabled \
	-Dtools=disabled

$(eval $(meson-package))
$(eval $(host-meson-package))
