############################################################
#
# Open2300
#
############################################################

OPEN2300_SITE        = http://www.lavrsen.dk/svn/open2300/trunk/
OPEN2300_SITE_METHOD = svn
OPEN2300_VERSION     = 12

OPEN2300_BINS = open2300 dump2300 log2300 fetch2300 wu2300 cw2300 history2300 \
		histlog2300 bin2300 xml2300 light2300 interval2300 minmax2300

ifeq ($(BR2_PACKAGE_MYSQL),y)
	OPEN2300_DEPENDENCIES += mysql_client
	OPEN2300_BINS         += mysql2300 mysqlhistlog2300
endif

define OPEN2300_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" -C $(@D) $(OPEN2300_BINS)
endef

define OPEN2300_INSTALL_TARGET_CMDS
	for prog in $(OPEN2300_BINS); do \
		$(INSTALL) -D -m 0755 $(@D)/$$prog $(TARGET_DIR)/usr/bin/$$prog ; \
	done
endef

$(eval $(generic-package))
