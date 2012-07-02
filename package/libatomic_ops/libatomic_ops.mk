#############################################################
#
# Atomic_ops library
#
#############################################################

LIBATOMIC_OPS_VERSION = 1.2
LIBATOMIC_OPS_SOURCE = libatomic_ops-$(LIBATOMIC_OPS_VERSION).tar.gz
LIBATOMIC_OPS_SITE = http://www.hpl.hp.com/research/linux/atomic_ops/download
LIBATOMIC_OPS_INSTALL_STAGING = YES

$(eval $(autotools-package))
