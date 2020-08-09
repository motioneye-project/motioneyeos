################################################################################
#
# pv
#
################################################################################

PV_VERSION = 1.6.6
PV_SOURCE = pv-$(PV_VERSION).tar.bz2
PV_SITE = http://www.ivarch.com/programs/sources
PV_LICENSE = Artistic-2.0
PV_LICENSE_FILES = doc/COPYING
PV_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

# --relax linker option is enabled by default on sparc/sparc64
# architectures, and it can't be used together with -r option, so
# disable it.
ifeq ($(BR2_sparc)$(BR2_sparc64),y)
PV_LDFLAGS = "-Wl,--no-relax"
endif

# While 'pv' uses autoconf, it does not use automake for its
# makefiles. It uses $(LD) $(LDFLAGS) to achieve partial linking, but
# using 'ld' directly doesn't work well with some toolchain
# configuration, as the ld default emulation may not necessarily be
# the correct one. By passing the below values for LD and LDFLAGS, we
# ensure that 'gcc' is used to do these partial linking steps.
PV_MAKE_OPTS = \
	LD="$(TARGET_CC)" \
	LDFLAGS="-Wl,-r -nostdlib $(PV_LDFLAGS)"

$(eval $(autotools-package))
