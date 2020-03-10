################################################################################
#
# rtty
#
################################################################################

RTTY_VERSION = 7.1.2
RTTY_SITE = https://github.com/zhaojh329/rtty/releases/download/v$(RTTY_VERSION)
RTTY_LICENSE = MIT
RTTY_LICENSE_FILES = LICENSE
RTTY_DEPENDENCIES = libev
RTTY_CONF_OPTS = -DRTTY_SSL_SUPPORT=OFF

$(eval $(cmake-package))
