RTAI_VERSION = 3.8.1
RTAI_SOURCE  = rtai-$(RTAI_VERSION).tar.bz2
RTAI_SITE    = http://www.rtai.org/RTAI/

RTAI_DEPENDENCIES = linux

RTAI_CONF_OPT = \
	--with-linux-dir=$(LINUX_DIR) 	\
	--disable-leds		      	\
	--disable-rtailab		\
	--with-module-dir=/lib/modules/$(LINUX_VERSION_PROBED)/rtai

RTAI_MAKE = $(MAKE1)

$(eval $(autotools-package))
