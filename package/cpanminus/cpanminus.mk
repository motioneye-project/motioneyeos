################################################################################
#
# cpanminus
#
################################################################################

CPANMINUS_VERSION = 1.6109
CPANMINUS_SOURCE = $(CPANMINUS_VERSION).tar.gz
CPANMINUS_SITE = https://github.com/miyagawa/cpanminus/archive
CPANMINUS_DEPENDENCIES = host-qemu perl $(call qstrip,$(BR2_PACKAGE_CPANMINUS_NATIVE_DEPENDENCIES))

CPANMINUS_RUN_PERL = $(QEMU_USER) $(STAGING_DIR)/usr/bin/perl
CPANMINUS_ARCHNAME = $(shell $(CPANMINUS_RUN_PERL) -MConfig -e "print Config->{archname}")
CPANMINUS_PERL_LIB      = $(STAGING_DIR)/usr/lib/perl
CPANMINUS_PERL_SITELIB  = $(TARGET_DIR)/usr/lib/perl
CPANMINUS_PERL_ARCHLIB  = $(CPANMINUS_PERL_LIB)/$(CPANMINUS_ARCHNAME)
CPANMINUS_PERL_SITEARCH = $(CPANMINUS_PERL_SITELIB)/$(CPANMINUS_ARCHNAME)
CPANMINUS_PERL5LIB = $(CPANMINUS_PERL_SITEARCH):$(CPANMINUS_PERL_SITELIB):$(CPANMINUS_PERL_ARCHLIB):$(CPANMINUS_PERL_LIB)
ifneq ($(BR2_PACKAGE_CPANMINUS_MIRROR),"")
    CPANMINUS_MIRROR = --mirror $(call qstrip,$(BR2_PACKAGE_CPANMINUS_MIRROR)) --mirror-only
endif
CPANMINUS_MODULES = $(call qstrip,$(BR2_PACKAGE_CPANMINUS_MODULES))

ifneq ($(CPANMINUS_MODULES),)
define CPANMINUS_INSTALL_TARGET_CMDS
	echo "#!/bin/sh"                                                        > $(@D)/run_perl
	echo "PERL5LIB=$(CPANMINUS_PERL5LIB) $(CPANMINUS_RUN_PERL) \"\$$@\""    >>$(@D)/run_perl
	chmod +x $(@D)/run_perl
	PERL5LIB=$(CPANMINUS_PERL5LIB) \
	PERL_MM_OPT="DESTDIR=$(CPANMINUS_PERL_SITELIB) PERL=$(@D)/run_perl PERL_LIB=$(CPANMINUS_PERL_LIB) PERL_ARCHLIB=$(CPANMINUS_PERL_ARCHLIB)" \
	PERL_MB_OPT="--destdir $(CPANMINUS_PERL_SITELIB)" \
	RUN_PERL="$(@D)/run_perl" \
	$(CPANMINUS_RUN_PERL) $(@D)/cpanm \
		--perl=$(@D)/run_perl \
		--notest \
		--no-man-pages \
		$(CPANMINUS_MIRROR) \
		$(call qstrip,$(BR2_PACKAGE_CPANMINUS_MODULES))
	-find $(CPANMINUS_PERL_SITEARCH) -type f -name *.bs -exec rm -f {} \;
endef
else
define CPANMINUS_INSTALL_TARGET_CMDS
	@echo "No modules to install"
endef
endif

$(eval $(generic-package))
