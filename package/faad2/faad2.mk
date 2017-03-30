################################################################################
#
# faad2
#
################################################################################

FAAD2_VERSION = 2.7
FAAD2_SITE = http://downloads.sourceforge.net/project/faac/faad2-src/faad2-$(FAAD2_VERSION)
FAAD2_LICENSE = GPL-2.0
FAAD2_LICENSE_FILES = COPYING
# frontend/faad calls frexp()
FAAD2_CONF_ENV = LIBS=-lm
FAAD2_INSTALL_STAGING = YES

$(eval $(autotools-package))
