################################################################################
#
# lsof
#
################################################################################

LSOF_VERSION = 4.89
LSOF_SOURCE = lsof_$(LSOF_VERSION).tar.bz2
# Use http mirror since master ftp site access is very draconian
LSOF_SITE = http://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof
LSOF_LICENSE = lsof license
# License is repeated in each file, this is a relatively small one.
# It is also defined in 00README, but that contains a lot of other cruft.
LSOF_LICENSE_FILES = dialects/linux/dproto.h

# Make certain full-blown lsof gets built after the busybox version (1.20+)
LSOF_DEPENDENCIES += $(if $(BR2_PACKAGE_BUSYBOX),busybox)

ifeq ($(BR2_USE_WCHAR),)
define LSOF_CONFIGURE_WCHAR_FIXUPS
	$(SED) 's,^#define[[:space:]]*HASWIDECHAR.*,#undef HASWIDECHAR,' \
		$(@D)/machine.h
endef
endif

ifeq ($(BR2_ENABLE_LOCALE),)
define LSOF_CONFIGURE_LOCALE_FIXUPS
	$(SED) 's,^#define[[:space:]]*HASSETLOCALE.*,#undef HASSETLOCALE,' \
		$(@D)/machine.h
endef
endif

# The .tar.bz2 contains another .tar, which contains the source code.
define LSOF_EXTRACT_CMDS
	$(call suitable-extractor,$(LSOF_SOURCE)) $(DL_DIR)/$(LSOF_SOURCE) | \
		$(TAR) -O $(TAR_OPTIONS) - lsof_$(LSOF_VERSION)/lsof_$(LSOF_VERSION)_src.tar | \
	$(TAR) --strip-components=1 -C $(LSOF_DIR) $(TAR_OPTIONS) -
endef

define LSOF_CONFIGURE_CMDS
	(cd $(@D) ; \
		echo n | $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS)" \
		LSOF_INCLUDE="$(STAGING_DIR)/usr/include" LSOF_CFLAGS_OVERRIDE=1 \
		LINUX_CLIB=-DGLIBCV=2 ./Configure linux)
	$(LSOF_CONFIGURE_WCHAR_FIXUPS)
	$(LSOF_CONFIGURE_LOCALE_FIXUPS)
endef

define LSOF_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) DEBUG="$(TARGET_CFLAGS)" -C $(@D)
endef

define LSOF_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/lsof $(TARGET_DIR)/usr/bin/lsof
endef

$(eval $(generic-package))
