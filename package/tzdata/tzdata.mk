################################################################################
#
# tzdata
#
################################################################################

TZDATA_VERSION = 2013i
TZDATA_SOURCE = tzdata$(TZDATA_VERSION).tar.gz
TZDATA_SITE = ftp://ftp.iana.org/tz/releases
TZDATA_DEPENDENCIES = host-zic
TZDATA_LICENSE = Public domain

TZDATA_DEFAULT_ZONELIST = africa antarctica asia australasia backward etcetera \
			europe factory northamerica pacificnew southamerica

ifeq ($(call qstrip,$(BR2_PACKAGE_TZDATA_ZONELIST)),default)
TZDATA_ZONELIST = $(TZDATA_DEFAULT_ZONELIST)
else
TZDATA_ZONELIST = $(call qstrip,$(BR2_PACKAGE_TZDATA_ZONELIST))
endif

# Don't strip any path components during extraction.
define TZDATA_EXTRACT_CMDS
	gzip -d -c $(DL_DIR)/$(TZDATA_SOURCE) \
		| $(TAR) --strip-components=0 -C $(@D) -xf -
endef

define TZDATA_BUILD_CMDS
	(cd $(@D); \
		for zone in $(TZDATA_ZONELIST); do \
			$(ZIC) -d _output/posix -y yearistype.sh $$zone; \
			$(ZIC) -d _output/right -L leapseconds -y yearistype.sh $$zone; \
		done; \
	)
endef

define TZDATA_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/zoneinfo
	cp -a $(@D)/_output/* $(TARGET_DIR)/usr/share/zoneinfo
	cd $(TARGET_DIR)/usr/share/zoneinfo;    \
	for zone in posix/*; do                 \
	    ln -sfn "$${zone}" "$${zone##*/}";    \
	done
endef

$(eval $(generic-package))
