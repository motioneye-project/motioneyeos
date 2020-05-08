################################################################################
#
# mbuffer
#
################################################################################

MBUFFER_VERSION = 20200505
MBUFFER_SOURCE = mbuffer-$(MBUFFER_VERSION).tgz
MBUFFER_SITE = http://www.maier-komor.de/software/mbuffer
MBUFFER_LICENSE = GPL-3.0+
MBUFFER_LICENSE_FILES = LICENSE
MBUFFER_CONF_OPTS = --disable-debug

# we don't need tests & co. so we specify a target
# so that the others don't get built, e.g idev.so
MBUFFER_MAKE_OPTS += mbuffer

$(eval $(autotools-package))
