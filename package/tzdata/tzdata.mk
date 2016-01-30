################################################################################
#
# tzdata
#
################################################################################

TZDATA_VERSION = 2016a
TZDATA_SOURCE = tzdata$(TZDATA_VERSION).tar.gz
TZDATA_SITE = http://www.iana.org/time-zones/repository/releases
TZDATA_STRIP_COMPONENTS = 0
TZDATA_DEPENDENCIES = host-tzdata
HOST_TZDATA_DEPENDENCIES = host-zic
TZDATA_LICENSE = Public domain

TZDATA_DEFAULT_ZONELIST = \
	africa antarctica asia australasia backward etcetera \
	europe factory northamerica pacificnew southamerica

ifeq ($(call qstrip,$(BR2_TARGET_TZ_ZONELIST)),default)
TZDATA_ZONELIST = $(TZDATA_DEFAULT_ZONELIST)
else
TZDATA_ZONELIST = $(call qstrip,$(BR2_TARGET_TZ_ZONELIST))
endif

TZDATA_LOCALTIME = $(call qstrip,$(BR2_TARGET_LOCALTIME))

# No need to extract for target, we're using the host-installed files
TZDATA_EXTRACT_CMDS =

define TZDATA_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/usr/share/zoneinfo
	cp -a $(HOST_DIR)/usr/share/zoneinfo/* $(TARGET_DIR)/usr/share/zoneinfo
	cd $(TARGET_DIR)/usr/share/zoneinfo;    \
	for zone in posix/*; do                 \
	    ln -sfn "$${zone}" "$${zone##*/}";  \
	done
	if [ -n "$(TZDATA_LOCALTIME)" ]; then                           \
	    if [ ! -f $(TARGET_DIR)/usr/share/zoneinfo/$(TZDATA_LOCALTIME) ]; then \
	        printf "Error: '%s' is not a valid timezone, check your BR2_TARGET_LOCALTIME setting\n" \
	               "$(TZDATA_LOCALTIME)";                           \
	        exit 1;                                                 \
	    fi;                                                         \
	    cd $(TARGET_DIR)/etc;                                       \
	    ln -sf ../usr/share/zoneinfo/$(TZDATA_LOCALTIME) localtime; \
	    echo "$(TZDATA_LOCALTIME)" >timezone;                       \
	fi
endef

define HOST_TZDATA_BUILD_CMDS
	(cd $(@D); \
		for zone in $(TZDATA_ZONELIST); do \
			$(ZIC) -d _output/posix -y yearistype.sh $$zone; \
			$(ZIC) -d _output/right -L leapseconds -y yearistype.sh $$zone; \
		done; \
	)
endef

define HOST_TZDATA_INSTALL_CMDS
	$(INSTALL) -d -m 0755 $(HOST_DIR)/usr/share/zoneinfo
	cp -a $(@D)/_output/* $(@D)/*.tab $(HOST_DIR)/usr/share/zoneinfo
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
