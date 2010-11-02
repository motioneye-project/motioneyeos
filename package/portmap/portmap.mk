#############################################################
#
# portmap
#
#############################################################

PORTMAP_VERSION = 6.0
PORTMAP_SOURCE = portmap-$(PORTMAP_VERSION).tgz
PORTMAP_SITE = http://neil.brown.name/portmap
PORTMAP_SBINS = portmap pmap_dump pmap_set

define PORTMAP_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) NO_TCP_WRAPPER=1
endef

define PORTMAP_INSTALL_TARGET_CMDS
	for sbin in $(PORTMAP_SBINS); do \
		$(INSTALL) -D $(@D)/$$sbin $(TARGET_DIR)/sbin/$$sbin; \
	done
	$(INSTALL) -D $(@D)/portmap.man \
		$(TARGET_DIR)/usr/share/man/man8/portmap.8
	$(INSTALL) -D $(@D)/pmap_dump.8 \
		$(TARGET_DIR)/usr/share/man/man8/pmap_dump.8
	$(INSTALL) -D $(@D)/pmap_set.8 \
		$(TARGET_DIR)/usr/share/man/man8/pmap_set.8
endef

define PORTMAP_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/sbin/,$(PORTMAP_SBINS))
	rm -f $(addprefix $(TARGET_DIR)/usr/share/man/man8/, \
		$(addsuffix .8,$(PORTMAP_SBINS)))
endef

$(eval $(call GENTARGETS,package,portmap))
