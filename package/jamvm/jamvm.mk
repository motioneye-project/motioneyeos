################################################################################
#
# jamvm
#
################################################################################

JAMVM_VERSION = 1.5.4
JAMVM_SITE = http://downloads.sourceforge.net/project/jamvm/jamvm/JamVM%20$(JAMVM_VERSION)
JAMVM_DEPENDENCIES = zlib classpath
# int inlining seems to crash jamvm, don't build shared version of internal lib
JAMVM_CONF_OPT = \
	--with-classpath-install-dir=/usr \
	--disable-int-inlining \
	--disable-shared \
	--without-pic

# jamvm has ARM assembly code that cannot be compiled in Thumb2 mode,
# so we must force traditional ARM mode.
ifeq ($(BR2_arm),y)
JAMVM_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -marm"
endif

$(eval $(autotools-package))
