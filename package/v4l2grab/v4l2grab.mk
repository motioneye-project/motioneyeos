################################################################################
#
# v4l2grab
#
################################################################################

V4L2GRAB_VERSION = 6a52a234e227a30e16591d1a0e7afc52a2c5d964
V4L2GRAB_SITE = $(call github,twam,v4l2grab,$(V4L2GRAB_VERSION))
V4L2GRAB_LICENSE = GPLv2+
V4L2GRAB_LICENSE_FILES = LICENSE.md
# Fetched from github, no pre-generated configure script provided
V4L2GRAB_AUTORECONF = YES
V4L2GRAB_DEPENDENCIES = jpeg libv4l

$(eval $(autotools-package))
