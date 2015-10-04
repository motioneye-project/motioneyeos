################################################################################
#
# gtksharp3
#
################################################################################

MONO_GTKSHARP3_VERSION_MAJOR = 2.99
MONO_GTKSHARP3_VERSION = $(MONO_GTKSHARP3_VERSION_MAJOR).3
MONO_GTKSHARP3_SITE = http://ftp.gnome.org/pub/gnome/sources/gtk-sharp/$(MONO_GTKSHARP3_VERSION_MAJOR)/
MONO_GTKSHARP3_SOURCE = gtk-sharp-$(MONO_GTKSHARP3_VERSION).tar.xz
MONO_GTKSHARP3_LICENSE = LGPLv2, MIT (cairo)
MONO_GTKSHARP3_LICENSE_FILES = COPYING
MONO_GTKSHARP3_INSTALL_STAGING = YES
MONO_GTKSHARP3_DEPENDENCIES = mono libgtk3
MONO_GTKSHARP3_CONF_OPTS += CSC=$(HOST_DIR)/usr/bin/mcs

$(eval $(autotools-package))
