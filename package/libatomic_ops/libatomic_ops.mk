################################################################################
#
# libatomic_ops
#
################################################################################

LIBATOMIC_OPS_VERSION = 7.2
LIBATOMIC_OPS_SITE = http://www.hpl.hp.com/research/linux/atomic_ops/download

# From doc/LICENSING.txt: "Our intent is to make it easy to use
# libatomic_ops, in both free and proprietary software.  Hence most
# code that we expect to be linked into a client application is
# covered by an MIT-style license. A few library routines are covered
# by the GNU General Public License. These are put into a separate
# library, libatomic_ops_gpl.a."
LIBATOMIC_OPS_LICENSE = MIT (main library) / GPLv2+ (gpl extension)
LIBATOMIC_OPS_LICENSE_FILES = doc/LICENSING.txt doc/COPYING

LIBATOMIC_OPS_INSTALL_STAGING = YES

$(eval $(autotools-package))
