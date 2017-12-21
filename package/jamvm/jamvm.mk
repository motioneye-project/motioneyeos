################################################################################
#
# jamvm
#
################################################################################

JAMVM_VERSION = 2.0.0
JAMVM_SITE = http://downloads.sourceforge.net/project/jamvm/jamvm/JamVM%20$(JAMVM_VERSION)
JAMVM_LICENSE = GPL-2.0+
JAMVM_LICENSE_FILES = COPYING
JAMVM_DEPENDENCIES = zlib classpath
# For 0001-Use-fenv.h-when-available-instead-of-fpu_control.h.patch
JAMVM_AUTORECONF = YES
# int inlining seems to crash jamvm, don't build shared version of internal lib
JAMVM_CONF_OPTS = \
	--with-classpath-install-dir=/usr \
	--disable-int-inlining \
	--disable-shared \
	--without-pic

# jamvm has ARM assembly code that cannot be compiled in Thumb2 mode,
# so we must force traditional ARM mode.
ifeq ($(BR2_arm),y)
JAMVM_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -marm"
endif

# Needed for autoreconf
define JAMVM_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef

JAMVM_POST_PATCH_HOOKS += JAMVM_CREATE_M4_DIR

$(eval $(autotools-package))
