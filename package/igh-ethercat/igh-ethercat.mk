IGH_ETHERCAT_VERSION = stable-1.5
IGH_ETHERCAT_SITE    = http://etherlabmaster.hg.sourceforge.net/hgweb/etherlabmaster/etherlabmaster/archive/
IGH_ETHERCAT_SOURCE  = $(IGH_ETHERCAT_VERSION).tar.bz2

IGH_ETHERCAT_AUTORECONF      = YES
IGH_ETHERCAT_DEPENDENCIES    = linux
IGH_ETHERCAT_INSTALL_STAGING = YES

IGH_ETHERCAT_CONF_OPT = \
	--with-linux-dir=$(LINUX_DIR)

IGH_ETHERCAT_CONF_OPT += $(if $(BR2_PACKAGE_IGH_ETHERCAT_8139TOO),--enable-8139too,--disable-8139too)
IGH_ETHERCAT_CONF_OPT += $(if $(BR2_PACKAGE_IGH_ETHERCAT_E100),--enable-e100,--disable-e100)
IGH_ETHERCAT_CONF_OPT += $(if $(BR2_PACKAGE_IGH_ETHERCAT_E1000),--enable-e1000,--disable-e1000)
IGH_ETHERCAT_CONF_OPT += $(if $(BR2_PACKAGE_IGH_ETHERCAT_R8169),--enable-r8169,--disable-r8169)

# Since we download ethercat from source control, we have to emulate
# the bootstrap script that creates the ChangeLog file before running
# autoreconf.  We don't want to run that script directly, since we
# leave to the autotargets infrastructure the responsability of
# running 'autoreconf' so that the dependencies on host-automake,
# host-autoconf and al. are correct.
define IGH_ETHERCAT_CREATE_CHANGELOG
	touch $(@D)/ChangeLog
endef

IGH_ETHERCAT_POST_PATCH_HOOKS += IGH_ETHERCAT_CREATE_CHANGELOG

define IGH_ETHERCAT_BUILD_MODULES
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) modules
endef

IGH_ETHERCAT_POST_BUILD_HOOKS += IGH_ETHERCAT_BUILD_MODULES

define IGH_ETHERCAT_INSTALL_MODULES
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) modules_install
endef

IGH_ETHERCAT_POST_INSTALL_TARGET_HOOKS += IGH_ETHERCAT_INSTALL_MODULES

$(eval $(call AUTOTARGETS))
