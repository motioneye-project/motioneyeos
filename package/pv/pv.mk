#######################
#
# pv - Pipe Viewer
#
#######################

PV_VERSION = 1.2.0
PV_SOURCE = pv-$(PV_VERSION).tar.bz2
PV_SITE = http://pipeviewer.googlecode.com/files

$(eval $(autotools-package))
