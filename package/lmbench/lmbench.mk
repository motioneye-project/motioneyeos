#############################################################
#
# lmbench
#
#############################################################
LMBENCH_VERSION:=3.0-a9
LMBENCH_SOURCE:=lmbench-$(LMBENCH_VERSION).tgz
LMBENCH_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/lmbench/development/lmbench-3.0-a9/

define LMBENCH_CONFIGURE_CMDS
	$(CONFIG_UPDATE) $(@D)
	sed -i 's/CFLAGS=/CFLAGS+=/g' $(@D)/src/Makefile
	sed -i '/cd .*doc/d' $(@D)/src/Makefile
	sed -i '/include/d' $(@D)/src/Makefile
	touch $@
endef

define LMBENCH_BUILD_CMDS
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" OS=$(ARCH) CC="$(TARGET_CC)" -C $(@D)/src
endef

define LMBENCH_INSTALL_TARGET_CMDS
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" OS=$(ARCH) CC="$(TARGET_CC)" BASE=$(TARGET_DIR)/usr -C $(@D)/src install
endef

define LMBENCH_CLEAN_CMDS
	$(MAKE) -C $(@D)/src clean
endef

$(eval $(call GENTARGETS,package,lmbench))
