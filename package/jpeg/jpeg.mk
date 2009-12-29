#############################################################
#
# jpeg (libraries needed by some apps)
#
#############################################################
# Copyright (C) 2001-2003 by Erik Andersen <andersen@codepoet.org>
# Copyright (C) 2002 by Tim Riker <Tim@Rikers.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA
JPEG_VERSION:=6b
JPEG_SITE:=ftp://ftp.uu.net/graphics/jpeg/
JPEG_SOURCE=jpegsrc.v$(JPEG_VERSION).tar.gz
JPEG_INSTALL_STAGING = YES
JPEG_INSTALL_TARGET = YES
JPEG_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install
JPEG_LIBTOOL_PATCH = NO
JPEG_CONF_OPT = --without-x --enable-shared --enable-static

$(eval $(call AUTOTARGETS,package,jpeg))

$(JPEG_HOOK_POST_INSTALL):
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtrans rdjpgcom wrjpgcom)
	touch $@
