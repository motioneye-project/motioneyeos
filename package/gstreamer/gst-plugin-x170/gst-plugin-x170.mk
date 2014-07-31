################################################################################
#
# gst-plugin-x170
#
################################################################################

GST_PLUGIN_X170_VERSION = 1.0
GST_PLUGIN_X170_SITE = ftp://ftp.linux4sam.org/pub/demo/linux4sam_1.9/codec

GST_PLUGIN_X170_LICENSE = BSD-1c
#A license file is included but it is just a placeholder

# There is no generated configure script in the tarball.
GST_PLUGIN_X170_AUTORECONF = YES
GST_PLUGIN_X170_AUTORECONF_OPT = -Im4/
GST_PLUGIN_X170_DEPENDENCIES = gstreamer libglib2 on2-8170-libs

$(eval $(autotools-package))
