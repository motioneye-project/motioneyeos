################################################################################
#
# oprofile
#
################################################################################

OPROFILE_VERSION = 1.1.0
OPROFILE_SITE = http://downloads.sourceforge.net/project/oprofile/oprofile/oprofile-$(OPROFILE_VERSION)
OPROFILE_LICENSE = GPLv2+
OPROFILE_LICENSE_FILES = COPYING
OPROFILE_CONF_OPTS = \
	--disable-account-check \
	--enable-gui=no \
	--with-kernel=$(STAGING_DIR)/usr

OPROFILE_BINARIES = \
	utils/ophelp pp/opannotate pp/oparchive pp/opgprof \
	pp/opreport opjitconv/opjitconv \
	utils/op-check-perfevents libabi/opimport \
	pe_counting/ocount

ifeq ($(BR2_i386),y)
OPROFILE_ARCH = i386
endif
ifeq ($(BR2_mipsel),y)
OPROFILE_ARCH = mips
endif
ifeq ($(BR2_powerpc),y)
OPROFILE_ARCH = ppc
endif
ifeq ($(BR2_x86_64),y)
OPROFILE_ARCH = x86-64
endif
ifeq ($(OPROFILE_ARCH),)
OPROFILE_ARCH = $(BR2_ARCH)
endif

OPROFILE_DEPENDENCIES = popt binutils host-pkgconf

ifeq ($(BR2_PACKAGE_LIBPFM4),y)
OPROFILE_DEPENDENCIES += libpfm4
endif

# When gettext is enabled, popt links with -lintl, specifies it in its
# popt.pc and has done so for the past 6+ years. But oprofile does not
# use pkconfig to find popt, so misses -lintl, which is important for
# a static build. We have to do the call to pkgconfig manually...
OPROFILE_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs popt`"

ifeq ($(BR2_STATIC_LIBS),)
define OPROFILE_INSTALL_SHARED_LIBRARY
	$(INSTALL) -m 755 $(@D)/libopagent/.libs/*.so* $(TARGET_DIR)/usr/lib/oprofile
endef
endif

define OPROFILE_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/lib/oprofile
	if [ -d $(@D)/events/$(OPROFILE_ARCH) ]; then \
		cp -dpfr $(@D)/events/$(OPROFILE_ARCH) \
			$(TARGET_DIR)/usr/share/oprofile; \
	fi
	$(INSTALL) -m 644 $(@D)/libregex/stl.pat $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -m 755 $(addprefix $(@D)/, $(OPROFILE_BINARIES)) $(TARGET_DIR)/usr/bin
	$(OPROFILE_INSTALL_SHARED_LIBRARY)
endef

$(eval $(autotools-package))
