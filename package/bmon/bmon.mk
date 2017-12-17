################################################################################
#
# bmon
#
################################################################################

BMON_VERSION = 4.0
BMON_SITE = https://github.com/tgraf/bmon/releases/download/v$(BMON_VERSION)
BMON_DEPENDENCIES = host-pkgconf libconfuse libnl ncurses
BMON_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
BMON_LICENSE = BSD-2-Clause, MIT
BMON_LICENSE_FILES = LICENSE.BSD LICENSE.MIT

# link dynamically unless explicitly requested otherwise
ifeq ($(BR2_STATIC_LIBS),)
BMON_CONF_OPTS += --disable-static
else
# forgets to explicitly link with pthread for libnl
BMON_CONF_OPTS += LIBS=-lpthread
endif

$(eval $(autotools-package))
