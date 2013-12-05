################################################################################
#
# log4cplus
#
################################################################################

LOG4CPLUS_VERSION = 1.1.2
LOG4CPLUS_SOURCE = log4cplus-$(LOG4CPLUS_VERSION).tar.xz
LOG4CPLUS_SITE = http://downloads.sourceforge.net/project/log4cplus/log4cplus-stable/$(LOG4CPLUS_VERSION)
LOG4CPLUS_LICENSE = Apache-2.0
LOG4CPLUS_LICENSE_FILES = LICENSE
LOG4CPLUS_INSTALL_STAGING = YES

$(eval $(autotools-package))
