################################################################################
#
# perl
#
################################################################################

# When updating the version here, also update support/scripts/scancpan
PERL_VERSION_MAJOR = 22
PERL_VERSION = 5.$(PERL_VERSION_MAJOR).2
PERL_SITE = http://www.cpan.org/src/5.0
PERL_SOURCE = perl-$(PERL_VERSION).tar.bz2
PERL_LICENSE = Artistic or GPLv1+
PERL_LICENSE_FILES = Artistic Copying README
PERL_INSTALL_STAGING = YES

PERL_CROSS_VERSION = 1.0.2
PERL_CROSS_BASE_VERSION = 5.$(PERL_VERSION_MAJOR).1
# DO NOT refactor with the github helper (the result is not the same)
PERL_CROSS_SITE = https://github.com/arsv/perl-cross/releases/download/$(PERL_CROSS_VERSION)
PERL_CROSS_SOURCE = perl-$(PERL_CROSS_BASE_VERSION)-cross-$(PERL_CROSS_VERSION).tar.gz
PERL_EXTRA_DOWNLOADS = $(PERL_CROSS_SITE)/$(PERL_CROSS_SOURCE)

PERL_CROSS_OLD_POD = perl$(subst .,,$(PERL_CROSS_BASE_VERSION))delta.pod
PERL_CROSS_NEW_POD = perl$(subst .,,$(PERL_VERSION))delta.pod

# We use the perlcross hack to cross-compile perl. It should
# be extracted over the perl sources, so we don't define that
# as a separate package. Instead, it is downloaded and extracted
# together with perl
define PERL_CROSS_EXTRACT
	$(call suitable-extractor,$(PERL_CROSS_SOURCE)) $(DL_DIR)/$(PERL_CROSS_SOURCE) | \
	$(TAR) --strip-components=1 -C $(@D) $(TAR_OPTIONS) -
endef
PERL_POST_EXTRACT_HOOKS += PERL_CROSS_EXTRACT

define PERL_CROSS_SET_POD
	$(SED) s/$(PERL_CROSS_OLD_POD)/$(PERL_CROSS_NEW_POD)/g $(@D)/Makefile
endef
PERL_POST_PATCH_HOOKS += PERL_CROSS_SET_POD

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
PERL_DEPENDENCIES += berkeleydb
endif
ifeq ($(BR2_PACKAGE_GDBM),y)
PERL_DEPENDENCIES += gdbm
endif

# We have to override LD, because an external multilib toolchain ld is not
# wrapped to provide the required sysroot options.
PERL_CONF_OPTS = \
	--target=$(GNU_TARGET_NAME) \
	--target-tools-prefix=$(TARGET_CROSS) \
	--prefix=/usr \
	-Dld="$(TARGET_CC)" \
	-Dccflags="$(TARGET_CFLAGS)" \
	-Dldflags="$(TARGET_LDFLAGS) -lm" \
	-Dmydomain="" \
	-Dmyhostname="noname" \
	-Dmyuname="Buildroot $(BR2_VERSION_FULL)" \
	-Dosname=linux \
	-Dosvers=$(LINUX_VERSION) \
	-Dperladmin=root

ifeq ($(shell expr $(PERL_VERSION_MAJOR) % 2), 1)
PERL_CONF_OPTS += -Dusedevel
endif

ifeq ($(BR2_STATIC_LIBS),y)
PERL_CONF_OPTS += --all-static --no-dynaloader
endif

PERL_MODULES = $(call qstrip,$(BR2_PACKAGE_PERL_MODULES))
ifneq ($(PERL_MODULES),)
PERL_CONF_OPTS += --only-mod=$(subst $(space),$(comma),$(PERL_MODULES))
endif

define PERL_CONFIGURE_CMDS
	(cd $(@D); HOSTCC='$(HOSTCC_NOCCACHE)' ./configure $(PERL_CONF_OPTS))
	$(SED) 's/UNKNOWN-/Buildroot $(BR2_VERSION_FULL) /' $(@D)/patchlevel.h
endef

define PERL_BUILD_CMDS
	$(MAKE1) -C $(@D) all
endef

define PERL_INSTALL_STAGING_CMDS
	$(MAKE1) -C $(@D) DESTDIR="$(STAGING_DIR)" install.perl
endef

define PERL_INSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) DESTDIR="$(TARGET_DIR)" install.perl
endef

HOST_PERL_CONF_OPTS = \
	-des \
	-Dprefix="$(HOST_DIR)/usr" \
	-Dcc="$(HOSTCC)"

define HOST_PERL_CONFIGURE_CMDS
	(cd $(@D); HOSTCC='$(HOSTCC_NOCCACHE)' ./Configure $(HOST_PERL_CONF_OPTS))
endef

define HOST_PERL_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define HOST_PERL_INSTALL_CMDS
	$(MAKE) -C $(@D) INSTALL_DEPENDENCE='' install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))

define PERL_FINALIZE_TARGET
	rm -rf $(TARGET_DIR)/usr/lib/perl5/$(PERL_VERSION)/pod
	rm -rf $(TARGET_DIR)/usr/lib/perl5/$(PERL_VERSION)/$(PERL_ARCHNAME)/CORE
	find $(TARGET_DIR)/usr/lib/perl5/ -name 'extralibs.ld' -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/usr/lib/perl5/ -name '*.bs' -print0 | xargs -0 rm -f
	find $(TARGET_DIR)/usr/lib/perl5/ -name '.packlist' -print0 | xargs -0 rm -f
endef
PERL_TARGET_FINALIZE_HOOKS += PERL_FINALIZE_TARGET
