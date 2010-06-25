#############################################################
#
# fbv
#
#############################################################
FBV_VERSION:=1.0b
FBV_SOURCE:=fbv-$(FBV_VERSION).tar.gz
FBV_SITE:=http://s-tech.elsat.net.pl/fbv

FBV_DEPENDENCIES = libpng jpeg libungif

#fbv donesn't support cross-compilation
define FBV_CONFIGURE_CMDS
	(cd $(FBV_DIR); rm -f config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		./configure \
		--prefix=/usr \
		--libs="-lz -lm" \
	)
endef

define FBV_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define FBV_INSTALL_TARGET_CMDS
	install -D $(@D)/fbv $(TARGET_DIR)/usr/bin/fbv
endef

define FBV_CLEAN_CMDS
	rm -f $(TARGET_DIR)/usr/bin/fbv
	-$(MAKE) -C $(@D) clean
endef

$(eval $(call AUTOTARGETS,package,fbv))
