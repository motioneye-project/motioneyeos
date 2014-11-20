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
OMNIORB_DEPENDENCIES = host-omniorb
HOST_OMNIORB_DEPENDENCIES = host-python
OMNIORB_INSTALL_TARGET = YES

# 0001-uclinux-is-also-linux.patch touches configure.ac
OMNIORB_AUTORECONF = YES

# omniorb is not python3 friendly, so force the python interpreter
OMNIORB_CONF_OPTS = ac_cv_path_PYTHON=$(HOST_DIR)/usr/bin/python2
HOST_OMNIORB_CONF_OPTS = ac_cv_path_PYTHON=$(HOST_DIR)/usr/bin/python2

# Defaulting long double support to a safe option for the
# mix of embedded targets, this could later be automated
# based on checking the capability of the cross toolchain
# for "__LONG_DOUBLE_128__".  Currently the host and target
# need to match because of the code generation done by the
# host tools during the target compile (ie headers generated
# on host are used in target build).
OMNIORB_CONF_OPTS += --disable-longdouble
HOST_OMNIORB_CONF_OPTS += --disable-longdouble

# The EmbeddedSystem define (set below in OMNIORB_ADJUST_TOOLDIR)
# enables building of just the lib and disables building of
# tools/apps/services.  In some cases the apps/services are still
# required.  The tools however are host related and should never
# be required on target.
define OMNIORB_ENABLE_EXTRA_APPS
$(SED) 's:SUBDIRS += lib:SUBDIRS += lib appl services:g' $(@D)/src/dir.mk
endef

ifeq ($(BR2_PACKAGE_OMNIORB_WITH_APPS),y)
OMNIORB_POST_PATCH_HOOKS += OMNIORB_ENABLE_EXTRA_APPS
endif

ifeq ($(BR2_PREFER_STATIC_LIB),y)
define OMNIORB_DISABLE_SHARED
	echo "BuildSharedLibrary =" >> $(@D)/mk/beforeauto.mk
endef
OMNIORB_POST_CONFIGURE_HOOKS += OMNIORB_DISABLE_SHARED
endif

# omniORB is not completely cross-compile friendly and has some
# assumptions where a couple host tools must be built and then
# used by the target build.  The host tools generate code from
# the IDL description language, which is then built into the
# cross compiled target OMNIORB application.
define OMNIORB_ADJUST_TOOLDIR
	# Point to the host folder to get HOST_OMNIORB tools
	$(SED) 's:TOOLBINDIR = $$(TOP)/$$(BINDIR):TOOLBINDIR = $(HOST_DIR)/usr/bin:g' $(@D)/mk/beforeauto.mk
	# Disables OMNIORB app/service/tool building
	echo "EmbeddedSystem=1" >> $(@D)/mk/beforeauto.mk
endef
OMNIORB_POST_CONFIGURE_HOOKS += OMNIORB_ADJUST_TOOLDIR

$(eval $(autotools-package))
$(eval $(host-autotools-package))
