################################################################################
#
# toolchain-external-blackfin-uclinux
#
################################################################################

TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION_MAJOR = 2014R1
TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION = $(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION_MAJOR)-RC2

ifeq ($(BR2_BINFMT_FLAT),y)
TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_SUBDIR = bfin-uclinux
else
TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_SUBDIR = bfin-linux-uclibc
endif

TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_SITE = http://downloads.sourceforge.net/project/adi-toolchain/$(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION_MAJOR)/$(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION)/i386
TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_SOURCE = blackfin-toolchain-$(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION).i386.tar.bz2
TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_EXTRA_DOWNLOADS = blackfin-toolchain-uclibc-full-$(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_VERSION).i386.tar.bz2

TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_STRIP_COMPONENTS = 3

# Special handling for Blackfin toolchain, because of the split in two
# tarballs, and the organization of tarball contents. The tarballs
# contain ./opt/uClinux/{bfin-uclinux,bfin-linux-uclibc} directories,
# which themselves contain the toolchain. This is why we strip more
# components than usual.
define TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_UCLIBC_EXTRA_EXTRACT
	$(call suitable-extractor,$(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_EXTRA_DOWNLOADS)) $(DL_DIR)/$(TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_EXTRA_DOWNLOADS) | \
		$(TAR) --strip-components=3 -C $(@D) $(TAR_OPTIONS) -
endef
TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_POST_EXTRACT_HOOKS += TOOLCHAIN_EXTERNAL_BLACKFIN_UCLINUX_UCLIBC_EXTRA_EXTRACT

$(eval $(toolchain-external-package))
