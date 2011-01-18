################################################################################
#
# musepack
#
################################################################################

MUSEPACK_VERSION =  r435
MUSEPACK_SITE = http://files.musepack.net/source
MUSEPACK_SOURCE = musepack_src_$(MUSEPACK_VERSION).tar.gz
MUSEPACK_DEPENDENCIES = libcuefile libreplaygain
MUSEPACK_AUTORECONF = YES
MUSEPACK_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package/multimedia,musepack))
