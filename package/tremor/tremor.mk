################################################################################
#
# tremor
#
################################################################################

TREMOR_SITE = http://svn.xiph.org/trunk/Tremor/
TREMOR_SITE_METHOD = svn
TREMOR_VERSION = 18153

TREMOR_AUTORECONF = YES
TREMOR_INSTALL_STAGING = YES
TREMOR_DEPENDENCIES = libogg

# tremor has ARM assembly code that cannot be compiled in Thumb2 mode,
# so we must force the traditional ARM mode.
ifeq ($(BR2_arm),y)
TREMOR_CONF_ENV = \
	CFLAGS="$(TARGET_CFLAGS) -marm"
endif

$(eval $(autotools-package))
