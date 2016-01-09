################################################################################
#
# lttng-modules
#
################################################################################

LTTNG_MODULES_VERSION = 2.7.1
LTTNG_MODULES_SITE = http://lttng.org/files/lttng-modules
LTTNG_MODULES_SOURCE = lttng-modules-$(LTTNG_MODULES_VERSION).tar.bz2
LTTNG_MODULES_LICENSE = LGPLv2.1/GPLv2 (kernel modules), MIT (lib/bitfield.h, lib/prio_heap/*)
LTTNG_MODULES_LICENSE_FILES = lgpl-2.1.txt gpl-2.0.txt mit-license.txt LICENSE

$(eval $(kernel-module))
$(eval $(generic-package))
