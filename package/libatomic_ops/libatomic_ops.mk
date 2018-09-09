################################################################################
#
# libatomic_ops
#
################################################################################

LIBATOMIC_OPS_VERSION = v7.6.6
LIBATOMIC_OPS_SITE = $(call github,ivmai,libatomic_ops,$(LIBATOMIC_OPS_VERSION))
LIBATOMIC_OPS_AUTORECONF = YES

# From doc/LICENSING.txt: "Our intent is to make it easy to use
# libatomic_ops, in both free and proprietary software.  Hence most
# code that we expect to be linked into a client application is
# covered by an MIT-style license. A few library routines are covered
# by the GNU General Public License. These are put into a separate
# library, libatomic_ops_gpl.a."
LIBATOMIC_OPS_LICENSE = MIT (main library) / GPL-2.0+ (gpl extension)
LIBATOMIC_OPS_LICENSE_FILES = doc/LICENSING.txt COPYING

LIBATOMIC_OPS_INSTALL_STAGING = YES

ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
LIBATOMIC_OPS_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -DAO_NO_SPARC_V9"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
