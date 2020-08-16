################################################################################
#
# localedef
#
################################################################################

# Use the same VERSION and SITE as target glibc
# As in glibc.mk, generate version string using:
#   git describe --match 'glibc-*' --abbrev=40 origin/release/MAJOR.MINOR/master | cut -d '-' -f 2-
LOCALEDEF_VERSION = 2.30-67-g4748829f86a458b76642f3e98b1d80f7b868e427
LOCALEDEF_SOURCE = glibc-$(LOCALEDEF_VERSION).tar.gz
LOCALEDEF_SITE = $(call github,bminor,glibc,$(LOCALEDEF_VERSION))
HOST_LOCALEDEF_DL_SUBDIR = glibc

HOST_LOCALEDEF_DEPENDENCIES = \
	$(BR2_MAKE_HOST_DEPENDENCY) \
	host-bison \
	host-gawk

HOST_LOCALEDEF_CONF_ENV += ac_cv_prog_MAKE="$(BR2_MAKE)"

# Even though we use the autotools-package infrastructure, we have to override
# the default configure commands for since we have to build out-of-tree, but we
# can't use the same 'symbolic link to configure' used with the gcc packages.
define HOST_LOCALEDEF_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	# Do the configuration
	(cd $(@D)/build; \
		$(HOST_LOCALEDEF_CONF_ENV) \
		$(HOST_CONFIGURE_OPTS) \
		$(SHELL) $(@D)/configure \
		libc_cv_forced_unwind=yes \
		libc_cv_ssp=no \
		--target=$(GNU_HOST_NAME) \
		--host=$(GNU_HOST_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--with-pkgversion="Buildroot" \
		--without-cvs \
		--disable-profile \
		--without-gd \
		--enable-obsolete-rpc)
endef

define HOST_LOCALEDEF_BUILD_CMDS
	$(HOST_MAKE_ENV) $(BR2_MAKE1) $(HOST_LOCALEDEF_MAKE_OPTS) \
		-C $(@D)/build locale/others
endef

# The makefile does not implement an install target for localedef
define HOST_LOCALEDEF_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/locale/localedef $(HOST_DIR)/bin/localedef
endef

$(eval $(host-autotools-package))
