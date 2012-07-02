#############################################################
#
# microperl
#
#############################################################

MICROPERL_VERSION = 5.12.4
MICROPERL_SITE = http://www.cpan.org/src/5.0
MICROPERL_SOURCE = perl-$(MICROPERL_VERSION).tar.bz2
MICROPERL_DEPENDENCIES = host-microperl
MICROPERL_MODS_DIR = /usr/lib/perl5/$(MICROPERL_VERSION)
MICROPERL_ARCH_DIR = $(MICROPERL_MODS_DIR)/$(GNU_TARGET_NAME)
MICROPERL_MODS = $(call qstrip,$(BR2_PACKAGE_MICROPERL_MODULES))

# Minimal set of modules required for 'perl -V' to work
MICROPERL_ARCH_MODS = Config.pm Config_git.pl Config_heavy.pl
MICROPERL_BASE_MODS = strict.pm

# CGI bundle
ifeq ($(BR2_PACKAGE_MICROPERL_BUNDLE_CGI),y)
MICROPERL_MODS += constant.pm CGI CGI.pm Carp.pm Exporter.pm overload.pm \
	vars.pm warnings.pm warnings/register.pm
endif

# Host microperl is actually full-blown perl
define HOST_MICROPERL_CONFIGURE_CMDS
	cd $(@D) ; \
	./Configure -Dcc="$(HOSTCC)" -Dprefix="$(HOST_DIR)/usr" \
		-Dloclibpth='/lib /lib64 /usr/lib /usr/lib64' -des
endef

define HOST_MICROPERL_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define HOST_MICROPERL_INSTALL_CMDS
	$(MAKE) -C $(@D) install
endef

ifeq ($(BR2_ENDIAN),"BIG")
define MICROPERL_BIGENDIAN
	$(SED) '/^byteorder=/d' $(@D)/uconfig.sh
	echo "byteorder='4321'" >>$(@D)/uconfig.sh
endef
endif

ifeq ($(BR2_LARGEFILE),y)
define MICROPERL_LARGEFILE
	$(SED) '/^uselargefiles=/d' $(@D)/uconfig.sh
	echo "uselargefiles='define'" >>$(@D)/uconfig.sh
endef
endif

ifeq ($(BR2_USE_WCHAR),y)
define MICROPERL_WCHAR
	$(SED) '/^d_mbstowcs=/d' -e '/^d_mbtowc=/d' -e '/^d_wcstombs=/d' \
		-e '/^d_wctomb=/d' $(@D)/uconfig.sh
	echo "d_mbstowcs='define'" >>$(@D)/uconfig.sh
	echo "d_mbtowc='define'" >>$(@D)/uconfig.sh
	echo "d_wcstombs='define'" >>$(@D)/uconfig.sh
	echo "d_wctomb='define'" >>$(@D)/uconfig.sh
endef
endif

define MICROPERL_CONFIGURE_CMDS
	$(SED) '/^archlib=/d' -e '/^archlibexp=/d' -e '/^optimize=/d' \
		-e '/^archname=/d' -e '/^d_poll=/d' -e '/^i_poll=/d' \
		-e '/^osname=/d' -e '/^u32type=/d' -e '/^d_archlib=/d' \
		-e '/^d_memset=/d' -e '/^i_fcntl=/d' -e '/^useperlio=/d' \
		-e '/^need_va_copy=/d' $(@D)/uconfig.sh
	$(SED) 's/5.12/$(MICROPERL_VERSION)/' $(@D)/uconfig.sh
	echo "archlib='$(MICROPERL_ARCH_DIR)'" >>$(@D)/uconfig.sh
	echo "archlibexp='$(MICROPERL_ARCH_DIR)'" >>$(@D)/uconfig.sh
	echo "d_archlib='define'" >>$(@D)/uconfig.sh
	echo "archname='$(GNU_TARGET_NAME)'" >>$(@D)/uconfig.sh
	echo "osname='linux'" >>$(@D)/uconfig.sh
	echo "cc='$(TARGET_CC)'" >>$(@D)/uconfig.sh
	echo "ccflags='$(TARGET_CFLAGS)'" >>$(@D)/uconfig.sh
	echo "optimize='$(TARGET_CFLAGS)'" >>$(@D)/uconfig.sh
	echo "usecrosscompile='define'" >>$(@D)/uconfig.sh
	echo "d_memset='define'" >>$(@D)/uconfig.sh
	echo "i_fcntl='define'" >>$(@D)/uconfig.sh
	echo "useperlio='define'" >>$(@D)/uconfig.sh
	echo "u32type='unsigned int'" >>$(@D)/uconfig.sh
	echo "need_va_copy='define'" >>$(@D)/uconfig.sh
	echo "d_poll='define'" >>$(@D)/uconfig.sh
	echo "i_poll='define'" >>$(@D)/uconfig.sh
	$(SED) 's/UNKNOWN-/Buildroot $(BR2_VERSION_FULL) /' $(@D)/patchlevel.h
	$(SED) 's/local\///' $(@D)/uconfig.sh
	$(MICROPERL_BIGENDIAN)
	$(MICROPERL_LARGEFILE)
	$(MICROPERL_WCHAR)
	$(MAKE) -C $(@D) -f Makefile.micro regen_uconfig
	cp -f $(@D)/uconfig.h $(@D)/config.h
	cp -f $(@D)/uconfig.sh $(@D)/config.sh
	echo "ccname='$(TARGET_CC)'" >>$(@D)/config.sh
	echo "PERL_CONFIG_SH=true" >>$(@D)/config.sh
	cd $(@D) ; $(HOST_DIR)/usr/bin/perl make_patchnum.pl ; \
	$(HOST_DIR)/usr/bin/perl configpm
endef

define MICROPERL_BUILD_CMDS
	$(MAKE) -f Makefile.micro -C $(@D) \
		CC="$(HOSTCC)" bitcount.h
	$(MAKE) -f Makefile.micro -C $(@D) \
		CC="$(TARGET_CC)" OPTIMIZE="$(TARGET_CFLAGS)"
endef

# Some extensions don't need a build run
# We try to build anyway to avoid a huge black list
# Just ignore make_ext.pl warning/errors
define MICROPERL_BUILD_EXTENSIONS
	for i in $(MICROPERL_MODS); do \
	cd $(@D); ln -sf $(HOST_DIR)/usr/bin/perl miniperl; \
		PERL5LIB=$(TARGET_DIR)/$(MICROPERL_ARCH_DIR) \
		$(HOST_DIR)/usr/bin/perl make_ext.pl MAKE="$(MAKE)" --nonxs \
		`echo $$i|sed -e 's/.pm//'`; \
	done
endef

define MICROPERL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/microperl $(TARGET_DIR)/usr/bin/microperl
	ln -sf microperl $(TARGET_DIR)/usr/bin/perl
	for i in $(MICROPERL_ARCH_MODS); do \
		$(INSTALL) -m 0644 -D $(@D)/lib/$$i \
			$(TARGET_DIR)/$(MICROPERL_ARCH_DIR)/$$i; \
	done
	for i in $(MICROPERL_BASE_MODS); do \
		$(INSTALL) -m 0644 -D $(@D)/lib/$$i \
			$(TARGET_DIR)/$(MICROPERL_MODS_DIR)/$$i; \
	done
	$(MICROPERL_BUILD_EXTENSIONS)
	for i in $(MICROPERL_MODS); do \
		j=`echo $$i|cut -d : -f 1` ; \
		if [ -d $(@D)/lib/$$j ] ; then \
			cp -af $(@D)/lib/$$j $(TARGET_DIR)/$(MICROPERL_MODS_DIR) ; \
		fi ; \
		if [ -f $(@D)/lib/$$i ] ; then \
			$(INSTALL) -m 0644 -D $(@D)/lib/$$i $(TARGET_DIR)/$(MICROPERL_MODS_DIR)/$$i; \
		fi ; \
	done
	# Remove test files
	find $(TARGET_DIR)/$(MICROPERL_MODS_DIR) -type f -name *.t \
		-exec rm -f {} \;
endef

define MICROPERL_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/perl
	rm -f $(TARGET_DIR)/usr/bin/microperl
	rm -rf $(TARGET_DIR)/usr/lib/perl5
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
