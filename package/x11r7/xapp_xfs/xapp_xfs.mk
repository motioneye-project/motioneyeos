################################################################################
#
# xapp_xfs
#
################################################################################

XAPP_XFS_VERSION = 1c8459eafc04997751ae3d200d0ec91e43e19b5b
XAPP_XFS_SITE = git://anongit.freedesktop.org/xorg/app/xfs
XAPP_XFS_LICENSE = MIT
XAPP_XFS_LICENSE_FILES = COPYING
XAPP_XFS_AUTORECONF = YES
# xfont_font-util is only needed due to autoreconf. When switching
# back to a tarball release, it can be removed.
XAPP_XFS_DEPENDENCIES = xfont_font-util xlib_libFS xlib_libXfont xproto_fontsproto

$(eval $(autotools-package))
