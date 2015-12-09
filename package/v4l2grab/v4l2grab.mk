################################################################################
#
# v4l2grab
#
################################################################################

V4L2GRAB_VERSION = 0abed72532bee02e545a1924b6883c839d50febf
V4L2GRAB_SITE = $(call github,twam,v4l2grab,$(V4L2GRAB_VERSION))
V4L2GRAB_LICENSE = GPLv2+
V4L2GRAB_LICENSE_FILES = LICENSE.md
# Fetched from github, no pre-generated configure script provided
V4L2GRAB_AUTORECONF = YES
V4L2GRAB_DEPENDENCIES = jpeg libv4l

$(eval $(autotools-package))
