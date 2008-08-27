#############################################################
#
# GtkPerf
#
#############################################################
GTKPERF_VERSION:=0.40
GTKPERF_SOURCE:=gtkperf_$(GTKPERF_VERSION).tar.gz
GTKPERF_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/gtkperf
GTKPERF_INSTALL_TARGET = YES
GTKPERF_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
GTKPERF_DEPENDENCIES = libgtk2

$(eval $(call AUTOTARGETS,package,gtkperf))

