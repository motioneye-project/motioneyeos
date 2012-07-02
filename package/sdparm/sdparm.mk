SDPARM_VERSION = 1.07
SDPARM_SOURCE = sdparm-$(SDPARM_VERSION).tgz
SDPARM_SITE = http://sg.danny.cz/sg/p/

$(eval $(autotools-package))
