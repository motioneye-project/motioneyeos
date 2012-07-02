#############################################################
#
# lshw
#
#############################################################

LSHW_VERSION = B.02.16
LSHW_SITE = http://ezix.org/software/files
LSHW_MAKE_OPT = CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" AR="$(TARGET_AR)" \
	RPM_OPT_FLAGS="$(TARGET_CFLAGS)" all
LSHW_MAKE_ENV = LIBS="$(if $(BR2_NEEDS_GETTEXT),-lintl)"
LSHW_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT),libintl)

define LSHW_BUILD_CMDS
	$(LSHW_MAKE_ENV) $(MAKE) -C $(@D)/src $(LSHW_MAKE_OPT)
endef

define LSHW_INSTALL_TARGET_CMDS
	$(LSHW_MAKE_ENV) $(MAKE) -C $(@D)/src DESTDIR=$(TARGET_DIR) \
		$(LSHW_MAKE_OPT) install
endef

$(eval $(generic-package))
