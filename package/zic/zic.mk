################################################################################
#
# zic
#
################################################################################

ZIC_VERSION = 2015c
ZIC_SOURCE = tzcode$(ZIC_VERSION).tar.gz
ZIC_SITE = ftp://ftp.iana.org/tz/releases
ZIC_LICENSE = Public domain

# Don't strip any path components during extraction.
define HOST_ZIC_EXTRACT_CMDS
	gzip -d -c $(DL_DIR)/$(ZIC_SOURCE) \
		| $(TAR) --strip-components=0 -C $(@D) -xf -
endef

define HOST_ZIC_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) zic
endef

define HOST_ZIC_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/zic $(HOST_DIR)/usr/sbin/zic
	$(INSTALL) -D -m 644 $(@D)/tzfile.h $(HOST_DIR)/usr/include/tzfile.h
endef

$(eval $(host-generic-package))

ZIC = $(HOST_DIR)/usr/sbin/zic
