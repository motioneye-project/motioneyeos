################################################################################
#
# gst1-shark
#
################################################################################

GST1_SHARK_VERSION = v0.6.1
GST1_SHARK_SITE =  https://github.com/RidgeRun/gst-shark.git
GST1_SHARK_SITE_METHOD = git
GST1_SHARK_GIT_SUBMODULES = YES

GST1_SHARK_LICENSE = LGPL-2.1+
GST1_SHARK_LICENSE_FILES = COPYING

GST1_SHARK_AUTORECONF = YES
GST1_SHARK_DEPENDENCIES = host-pkgconf gstreamer1 gst1-plugins-base
GST1_SHARK_CONF_OPTS = --disable-graphviz

$(eval $(autotools-package))
