################################################################################
#
# omniorb
#
################################################################################

OMNIORB_VERSION = 4.1.6
OMNIORB_SITE = http://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-$(OMNIORB_VERSION)
OMNIORB_SOURCE = omniORB-$(OMNIORB_VERSION).tar.bz2
OMNIORB_INSTALL_STAGING = YES
OMNIORB_LICENSE = GPL2+ LGPLv2.1+
OMNIORB_LICENSE_FILES = COPYING COPYING.LIB
# Required for internal code generation scripts
OMNIORB_DEPENDENCIES = host-python

ifeq ($(BR2_PACKAGE_PYTHON),y)
	OMNIORB_DEPENDENCIES += python
	OMNIORB_CONF_OPT += --enable-python-bindings
else
	OMNIORB_CONF_OPT += --disable-python-bindings
endif

# omniORB is currently not cross-compile friendly and has some assumptions
# where a couple host tools are built in place and then used during the
# build.  The tools generate code from the IDL description language, which
# is then built into the cross compiled OMNIORB application.
# So this first hook builds the tools required for the host side
# generation of code. Then the second hook cleans up before the install.
define OMNIORB_BUILD_TOOLS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) \
		-C $(@D)/src/tool export
endef
OMNIORB_POST_CONFIGURE_HOOKS += OMNIORB_BUILD_TOOLS

define OMNIORB_CLEAN_TOOLS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) \
		-C $(@D)/src/tool clean
endef
OMNIORB_POST_BUILD_HOOKS += OMNIORB_CLEAN_TOOLS

define OMNIORB_FIXUP_FILE_PATHS_HOOK
	$(SED) "s:$(HOST_DIR)/usr:/usr:g" $(STAGING_DIR)/usr/bin/omniidl
endef
OMNIORB_POST_INSTALL_STAGING_HOOKS += OMNIORB_FIXUP_FILE_PATHS_HOOK

$(eval $(autotools-package))
