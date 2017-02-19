################################################################################
#
# v4l2grab
#
################################################################################

V4L2GRAB_VERSION = f8d8844d52387b3db7b8736f5e86156d9374f781
V4L2GRAB_SITE = $(call github,twam,v4l2grab,$(V4L2GRAB_VERSION))
V4L2GRAB_LICENSE = GPLv2+
V4L2GRAB_LICENSE_FILES = LICENSE.md
# Fetched from github, no pre-generated configure script provided
V4L2GRAB_AUTORECONF = YES
V4L2GRAB_DEPENDENCIES = jpeg libv4l

$(eval $(autotools-package))
