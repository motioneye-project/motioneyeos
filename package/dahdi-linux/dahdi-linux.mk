################################################################################
#
# dahdi-linux
#
################################################################################

DAHDI_LINUX_VERSION = 2.11.1
DAHDI_LINUX_SITE = http://downloads.asterisk.org/pub/telephony/dahdi-linux/releases

# We need to download all thoe firmware blobs ourselves, otherwise
# dahdi-linux will try to download them at install time.
DAHDI_LINUX_FW_SITE = http://downloads.digium.com/pub/telephony/firmware/releases
DAHDI_LINUX_FW_FILES = \
	dahdi-fwload-vpmadt032-1.25.0.tar.gz \
	dahdi-fw-oct6114-032-1.05.01.tar.gz \
	dahdi-fw-oct6114-064-1.05.01.tar.gz \
	dahdi-fw-oct6114-128-1.05.01.tar.gz \
	dahdi-fw-oct6114-256-1.05.01.tar.gz \
	dahdi-fw-tc400m-MR6.12.tar.gz \
	dahdi-fw-hx8-2.06.tar.gz \
	dahdi-fw-vpmoct032-1.12.0.tar.gz \
	dahdi-fw-te820-1.76.tar.gz \
	dahdi-fw-te133-7a001e.tar.gz \
	dahdi-fw-te134-780017.tar.gz \
	dahdi-fw-a8b-1f001e.tar.gz \
	dahdi-fw-a8a-1d0017.tar.gz \
	dahdi-fw-a4b-d001e.tar.gz \
	dahdi-fw-a4a-a0017.tar.gz \
	dahdi-fw-te435-13001e.tar.gz \
	dahdi-fw-te436-10017.tar.gz

DAHDI_LINUX_EXTRA_DOWNLOADS = \
	$(patsubst %,$(DAHDI_LINUX_FW_SITE)/%,$(DAHDI_LINUX_FW_FILES))

# dahdi-linux claims to be GPLv2 with parts LGPLv2.1 (not 'or later'),
# but there are the so-called firmware files (downloaded above) for
# which the license is unclear: the header claims to be GPLv2, the
# 'loader-wrapper' claims to be GPLv2, but there are two so-called
# 'firmware' binary-only .o blobs for which the license is not
# explicited, which look like they end up as part of a kernel module,
# and for which the source is nowhere to be found on the upstream site
# (they are only for x86/x86_64, but we still list them unconditionally).
DAHDI_LINUX_LICENSE = GPL-2.0, LGPL-2.1, unknown (firmware files)
DAHDI_LINUX_LICENSE_FILES = LICENSE LICENSE.LGPL

DAHDI_LINUX_INSTALL_STAGING = YES

DAHDI_LINUX_MODULE_SUBDIRS = drivers/dahdi

DAHDI_LINUX_MODULE_MAKE_OPTS = \
	KSRC=$(LINUX_DIR) \
	KVERS=$(LINUX_VERSION_PROBED) \
	DAHDI_BUILD_ALL=m \
	DAHDI_INCLUDE=$(@D)/include \
	INSTALL_MOD_DIR=dahdi

define DAHDI_LINUX_EXTRACT_FW
	$(foreach f,$(DAHDI_LINUX_FW_FILES),\
		cp $(DAHDI_LINUX_DL_DIR)/$(f) $(@D)/drivers/dahdi/firmware/$(f)$(sep))
endef
DAHDI_LINUX_POST_EXTRACT_HOOKS += DAHDI_LINUX_EXTRACT_FW

# Need to pass the same options as for building the modules, because
# it wants to scan Linux' .config file to check whether some options
# are set or not (like CONFIG_FW_LOADER).
define DAHDI_LINUX_CONFIGURE_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(DAHDI_LINUX_MODULE_MAKE_OPTS) \
		prereq
endef

define DAHDI_LINUX_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(DAHDI_LINUX_MODULE_MAKE_OPTS) \
		DESTDIR=$(STAGING_DIR) \
		install-include
endef

define DAHDI_LINUX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(DAHDI_LINUX_MODULE_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) \
		install-firmware \
		install-xpp-firm
endef

$(eval $(kernel-module))
$(eval $(generic-package))
