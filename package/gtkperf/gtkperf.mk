################################################################################
#
# gtkperf
#
################################################################################

GTKPERF_VERSION = 0.40
GTKPERF_SOURCE = gtkperf_$(GTKPERF_VERSION).tar.gz
GTKPERF_SITE = http://downloads.sourceforge.net/project/gtkperf/gtkperf/$(GTKPERF_VERSION)
GTKPERF_DEPENDENCIES = libgtk2
GTKPERF_LICENSE = GPLv2
GTKPERF_LICENSE_FILES = COPYING

$(eval $(autotools-package))
