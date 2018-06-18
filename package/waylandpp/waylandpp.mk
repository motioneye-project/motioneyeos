################################################################################
#
# waylandpp
#
################################################################################

WAYLANDPP_VERSION = 0.2.3
WAYLANDPP_SITE = $(call github,NilsBrause,waylandpp,$(WAYLANDPP_VERSION))
WAYLANDPP_LICENSE = MIT, GPL-3.0+ (wayland_scanner)
WAYLANDPP_LICENSE_FILES = LICENSE scanner/gpl-3.0.txt
WAYLANDPP_INSTALL_STAGING = YES
HOST_WAYLANDPP_DEPENDENCIES = host-pkgconf host-wayland
WAYLANDPP_DEPENDENCIES = libegl host-pkgconf wayland host-waylandpp

# host variant of wayland-scanner++ is needed for building the target
# package
HOST_WAYLANDPP_CONF_OPTS = \
	-DBUILD_LIBRARIES=OFF \
	-DBUILD_SCANNER=ON

WAYLANDPP_CONF_OPTS = \
	-DBUILD_LIBRARIES=ON \
	-DBUILD_SCANNER=OFF \
	-DWAYLAND_SCANNERPP=$(HOST_DIR)/bin/wayland-scanner++

$(eval $(cmake-package))
$(eval $(host-cmake-package))
