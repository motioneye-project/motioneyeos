################################################################################
#
# pv
#
################################################################################

PV_VERSION = 1.4.12
PV_SOURCE = pv-$(PV_VERSION).tar.bz2
PV_SITE = http://www.ivarch.com/programs/sources
PV_LICENSE = Artistic-2.0
PV_LICENSE_FILES = doc/COPYING
PV_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

# While 'pv' uses autoconf, it does not use automake for its
# makefiles. It uses $(LD) $(LDFLAGS) to achieve partial linking, but
# using 'ld' directly doesn't work well with some toolchain
# configuration, as the ld default emulation may not necessarily be
# the correct one. By passing the below values for LD and LDFLAGS, we
# ensure that 'gcc' is used to do these partial linking steps.
PV_MAKE_OPT = \
	LD="$(TARGET_CC)" \
	LDFLAGS="-Wl,-r -nostdlib"

$(eval $(autotools-package))
