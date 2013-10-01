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

# Defaulting long double support to a safe option for the
# mix of embedded targets, this could later be automated
# based on checking the capability of the cross toolchain
# for "__LONG_DOUBLE_128__".  Currently the host and target
# need to match because of the code generation done by the
# host tools during the target compile (ie headers generated
# on host are used in target build).
OMNIORB_CONF_OPT += --disable-longdouble
HOST_OMNIORB_CONF_OPT += --disable-longdouble

# omniORB is not completely cross-compile friendly and has some
# assumptions where a couple host tools must be built and then
# used by the target build.  The host tools generate code from
# the IDL description language, which is then built into the
# cross compiled target OMNIORB application.
define OMNIORB_ADJUST_TOOLDIR
	# Point to the host folder to get HOST_OMNIORB tools
	$(SED) 's:TOOLBINDIR = $$(TOP)/$$(BINDIR):TOOLBINDIR = $(HOST_DIR)/usr/bin:g' $(@D)/mk/beforeauto.mk
	# Disables OMNIORB tool building
	echo "EmbeddedSystem=1" >> $(@D)/mk/beforeauto.mk
endef
OMNIORB_POST_CONFIGURE_HOOKS += OMNIORB_ADJUST_TOOLDIR

$(eval $(autotools-package))
$(eval $(host-autotools-package))
