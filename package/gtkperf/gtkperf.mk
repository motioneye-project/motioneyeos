################################################################################
#
# gtkperf
#
################################################################################

GTKPERF_VERSION = 0.40
GTKPERF_SOURCE = gtkperf_$(GTKPERF_VERSION).tar.gz
GTKPERF_SITE = http://downloads.sourceforge.net/project/gtkperf/gtkperf/$(GTKPERF_VERSION)
GTKPERF_DEPENDENCIES = libgtk2 $(TARGET_NLS_DEPENDENCIES)
GTKPERF_LICENSE = GPL-2.0
GTKPERF_LICENSE_FILES = COPYING
GTKPERF_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
