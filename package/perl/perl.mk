#############################################################
#
# perl
#
#############################################################

PERL_VERSION_MAJOR = 16
PERL_VERSION = 5.$(PERL_VERSION_MAJOR).1
PERL_SITE = http://www.cpan.org/src/5.0
PERL_SOURCE = perl-$(PERL_VERSION).tar.bz2
PERL_LICENSE = Artistic
PERL_LICENSE_FILES = Artistic
PERL_INSTALL_STAGING = YES

PERL_DEPENDENCIES = host-qemu
ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
    PERL_DEPENDENCIES += berkeleydb
endif
ifeq ($(BR2_PACKAGE_GDBM),y)
    PERL_DEPENDENCIES += gdbm
endif

PERL_CONF_OPT = -des \
		-Dusecrosscompile \
		-Dtargetrun=$(QEMU_USER) \
		-Dqemulib=$(STAGING_DIR) \
		-Dar="$(TARGET_AR)" \
		-Dcc="$(TARGET_CC)" \
		-Dcpp="$(TARGET_CC)" \
		-Dld="$(TARGET_LD)" \
		-Dnm="$(TARGET_NM)" \
		-Dranlib="$(TARGET_RANLIB)" \
		-Dccflags="$(TARGET_CFLAGS)" \
		-Dldflags="$(TARGET_LDFLAGS) -lgcc_s -lm" \
		-Dlddlflags="-shared" \
		-Dlibc=$(STAGING_DIR)/lib/libc.so \
		-Duseshrplib \
		-Dprefix=/usr \
		-Uoptimize

ifeq ($(shell expr $(PERL_VERSION_MAJOR) % 2), 1)
    PERL_CONF_OPT += -Dusedevel
endif

ifneq ($(BR2_LARGEFILE),y)
    PERL_CONF_OPT += -Uuselargefiles
endif

define PERL_CONFIGURE_CMDS
	rm -f $(@D)/config.sh
	(cd $(@D); ./Configure $(PERL_CONF_OPT))
	echo "# patched values"                                 >>$(@D)/config.sh
	$(SED) '/^myarchname=/d' \
		-e '/^mydomain=/d' \
		-e '/^myhostname=/d' \
		-e '/^myuname=/d' \
		-e '/^osname=/d' \
		-e '/^osvers=/d' \
		-e '/^perladmin=/d' \
		$(@D)/config.sh
	echo "myarchname='$(GNU_TARGET_NAME)'"                  >>$(@D)/config.sh
	echo "mydomain=''"                                      >>$(@D)/config.sh
	echo "myhostname='$(BR2_TARGET_GENERIC_HOSTNAME)'"      >>$(@D)/config.sh
	echo "myuname='Buildroot $(BR2_VERSION_FULL)'"          >>$(@D)/config.sh
	echo "osname='linux'"                                   >>$(@D)/config.sh
	echo "osvers='$(BR2_LINUX_KERNEL_VERSION)'"             >>$(@D)/config.sh
	echo "perladmin='root'"                                 >>$(@D)/config.sh
	(cd $(@D); ./Configure -S)
	cp $(@D)/config.h $(@D)/xconfig.h
	$(SED) 's/UNKNOWN-/Buildroot $(BR2_VERSION_FULL) /' $(@D)/patchlevel.h
endef

define PERL_BUILD_CMDS
	echo "#!/bin/sh"                                > $(@D)/Cross/miniperl
	echo "$(QEMU_USER) $(@D)/miniperl \"\$$@\""     >>$(@D)/Cross/miniperl
	chmod +x $(@D)/Cross/miniperl
	PERL_MM_OPT="PERL=$(@D)/Cross/miniperl" \
		$(MAKE) -C $(@D) all
endef

define PERL_INSTALL_STAGING_CMDS
	$(MAKE) INSTALL_DEPENDENCE= \
		INSTALLFLAGS= \
		DESTDIR="$(STAGING_DIR)" \
		-C $(@D) install.perl
endef

PERL_RUN_PERL = $(QEMU_USER) $(@D)/perl -Ilib
PERL_ARCHNAME = $(shell $(PERL_RUN_PERL) -MConfig -e "print Config->{archname}")
PERL_LIB = $(TARGET_DIR)/usr/lib/perl5/$(PERL_VERSION)
PERL_ARCHLIB = $(PERL_LIB)/$(PERL_ARCHNAME)
PERL_MODS = $(call qstrip,$(BR2_PACKAGE_PERL_MODULES))
# Minimal set of modules required for 'perl -V' to work
PERL_ARCH_MODS = Config.pm Config_git.pl Config_heavy.pl
PERL_BASE_MODS = strict.pm vars.pm warnings.pm warnings/register.pm

define PERL_INSTALL_MODULES
	for i in $(PERL_ARCH_MODS); do \
		$(INSTALL) -m 0644 -D $(@D)/lib/$$i $(PERL_ARCHLIB)/$$i; \
	done
	for i in $(PERL_BASE_MODS); do \
		$(INSTALL) -m 0644 -D $(@D)/lib/$$i $(PERL_LIB)/$$i; \
	done
	for i in $(PERL_MODS); do \
		j=`echo $$i|cut -d : -f 1` ; \
		if [ -d $(@D)/lib/$$j ] ; then \
			cp -af $(@D)/lib/$$j $(PERL_LIB) ; \
		fi ; \
		if [ -f $(@D)/lib/$$i ] ; then \
			$(INSTALL) -m 0644 -D $(@D)/lib/$$i $(PERL_LIB)/$$i; \
		fi ; \
	done
	# Remove test files
	find $(PERL_LIB) -type f -name *.t -exec rm -f {} \;
endef

ifeq ($(BR2_PACKAGE_PERL_CUSTOM_INSTALL),y)
define PERL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/perl $(TARGET_DIR)/usr/bin/perl
	$(INSTALL) -m 0755 -D $(@D)/libperl.so $(PERL_ARCHLIB)/CORE/libperl.so
	$(PERL_INSTALL_MODULES)
endef
else
define PERL_INSTALL_TARGET_CMDS
	$(MAKE) INSTALL_DEPENDENCE= \
		INSTALLFLAGS=-p \
		DESTDIR="$(TARGET_DIR)" \
		-C $(@D) install.perl
	rm -f $(PERL_ARCHLIB)/CORE/*.h
	find $(PERL_ARCHLIB) -type f -name *.bs -exec rm -f {} \;
endef
endif

define PERL_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
